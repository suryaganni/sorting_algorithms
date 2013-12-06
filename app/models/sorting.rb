class Sorting

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Translation

  attr_accessor :array_list, :sorting_type, :sorted_list, :input_list

  SORTING_TYPE = [["Bubble Sort", 1], ["Insertion Sort", 2], ["Selection Sort", 3], ["Quick Sort", 4], ["Merge Sort", 5], ["Radix Sort", 6], ["Heap Sort", 7]]

  validates :array_list, :presence => true
  validates :sorting_type, :presence => true

  def persisted?
    false
  end

  def initialize(options={})
    self.array_list = options[:array_list]
    self.sorting_type = options[:sorting_type]
    self.input_list = options[:array_list]
    self.sorted_list = []
  end

  def sort_list
    if !valid?
      return false
    end
    self.trim_list
    case self.sorting_type
    when "1"
      self.bubble_sort
    when "2"
      self.insertion_sort
    when "3"
      self.selection_sort
    when "4"
      self.quick_sort
    when "5"
      self.merge_sort
    when "6"
      self.radix_sort
    when "7"
      self.heap_sort
    else
      []
    end
  end

  def trim_list
    self.array_list = self.array_list.split(",").map(&:to_i)
  end

  # Bubble Sort Start

  def bubble_sort
    array_length = array_list.length
    for j in 0..array_length-1
      array_list[0..array_length-1-j].each_with_index do |v, i|
        if array_length-1 > i && array_list[i] > array_list[i+1]
          array_list[i], array_list[i+1] = array_list[i+1], array_list[i]
        end
      end
    end
    self.sorted_list = array_list
  end

  # Bubble Sort End

  # Insertion Sort Start

  def insertion_sort
    array_length = array_list.length
    array_list.each_with_index do |v, i|
      if array_length - 1 > i && array_list[i] > array_list[i+1]
        array_list[i], array_list[i+1] = array_list[i+1], array_list[i]
        j = i
        while j > 0 do
          if array_list[j] < array_list[j-1]
            array_list[j], array_list[j-1] = array_list[j-1], array_list[j]
          else
            break
          end
          j = j-1
        end
      end
    end
    self.sorted_list = array_list
  end

  # Insertion Sort End

  # Selection Sort Start

  def selection_sort
    array_length = array_list.length
    for j in 0..array_length-1
      array_list.each_with_index do |v, i|
        if array_list[j] > array_list[i]
          array_list[j], array_list[i] = array_list[i], array_list[j]
        end
      end
    end
    self.sorted_list = array_list
  end

  # Selection Sort End

  # Quick Sort Start

  def quick(l, r)
    pointer = l-1
    pivot = array_list[r]
    l.upto(r) do |index|
      if array_list[index] <= pivot
        pointer = pointer + 1
        array_list[pointer], array_list[index] = array_list[index], array_list[pointer]
      end
    end
    return pointer
  end

  def partition_array(l, r)
    if l < r 
      pointer = quick(l, r)
      partition_array(l, pointer-1)
      partition_array(pointer, r)
    end
  end

  def quick_sort
    array_length = array_list.length
    self.partition_array(0, array_length-1)
    self.sorted_list = array_list
  end

  # Quick Sort End

  # Merge Sort Start

  def merge_sort
    Sorting.split_array(array_list, self)
  end

  def self.split_array(array_list, object)
    if array_list.length <= 1
      return array_list
    end
    mid = (array_list.length/2).round
    l = Sorting.split_array(array_list.take(mid), object)
    r = Sorting.split_array(array_list.drop(mid), object)
    if object.present?
      object.sorted_list = Sorting.merge(l, r)
    end    
  end

  def self.merge(l, r)
    if l.empty?
      return r
    elsif r.empty?
      return l
    end
    if l.first > r.first
      t = r.shift
    else
      t = l.shift
    end
    Sorting.merge(l, r).unshift(t)
  end

  # Merge Sort End

  # Radix Sort Start

  def radix_sort
    if !self.array_list.empty?
      max_element_length = self.array_list.max.to_s.length
      max_element_length.times do |t|
        index_value = (t + 1)*-1
        temp_array = []
        self.array_list.each do |v|
          ordering_value = v.to_s[index_value]
          if !ordering_value.nil?
            temp_array[ordering_value.to_i] ||= []
            temp_array[ordering_value.to_i] << v
          else
            temp_array[0] ||= []
            temp_array[0] << v
          end
        end
        self.array_list = temp_array.flatten.compact
      end
    end
    self.sorted_list = self.array_list
  end

  # Radix Sort End

  # Heap Sort Start

  def heapify(i)
    lchild = 2 * i + 1 < array_list.length ? 2 * i + 1 : i 
    rchild = 2 * i + 2 < array_list.length ? 2 * i + 2 : i
    flag = i
    flag = lchild if array_list[flag] < array_list[lchild]
    flag = rchild if array_list[flag] < array_list[rchild]
    if flag != i
      array_list[i], array_list[flag] = array_list[flag], array_list[i]
      self.heapify(flag)
    end
  end

  def adjust_heap
    top = array_list[0]
    array_list[0], array_list[-1] = array_list[-1], array_list[0]
    array_list.pop()
    return top
  end

  def heap_sort
    i = array_list.length / 2 - 1
    while i >= 0
      self.heapify(i)
      i -= 1
    end
    sorted_list.push(self.adjust_heap)
    self.heap_sort if array_list.length > 0
  end

  # Heap Sort End

end
