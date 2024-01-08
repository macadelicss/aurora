module Wrap
  class DuctTape
    def self.dualpivotquicksort(container)
      return container if container.size <= 1
      dualpivot(container, 0, container.size-1, 3)
    end

    def self.dualpivot(container, left=0, right=container.size-1, div=3)
      length = right - left
      if length < 27 # insertion sort for tiny array
        container.each_with_index do |data,i|
          j = i - 1
          while j >= 0
            break if container[j] <= data
            container[j + 1] = container[j]
            j = j - 1
          end
          container[j + 1] = data
        end
      else # full dual-pivot quicksort
        third = length / div
        # medians
        m1 = left + third
        m2 = right - third
        if m1 <= left
          m1 = left + 1
        end
        if m2 >= right
          m2 = right - 1
        end
        if container[m1] < container[m2]
          dualpivot_swap(container, m1, left)
          dualpivot_swap(container, m2, right)
        else
          dualpivot_swap(container, m1, right)
          dualpivot_swap(container, m2, left)
        end
        # pivots
        pivot1 = container[left]
        pivot2 = container[right]
        # pointers
        less = left + 1
        great = right - 1
        # sorting
        k = less
        while k <= great
          if container[k] < pivot1
            dualpivot_swap(container, k, less += 1)
          elsif container[k] > pivot2
            while k < great && container[great] > pivot2
              great -= 1
            end
            dualpivot_swap(container, k, great -= 1)
            if container[k] < pivot1
              dualpivot_swap(container, k, less += 1)
            end
          end
          k += 1
        end
        # swaps
        dist = great - less
        if dist < 13
          div += 1
        end
        dualpivot_swap(container, less-1, left)
        dualpivot_swap(container, great+1, right)
        # subarrays
        dualpivot(container, left, less-2, div)
        dualpivot(container, great+2, right, div)
        # equal elements
        if dist > length - 13 && pivot1 != pivot2
          for k in less..great do
            if container[k] == pivot1
              dualpivot_swap(container, k, less)
              less += 1
            elsif container[k] == pivot2
              dualpivot_swap(container, k, great)
              great -= 1
              if container[k] == pivot1
                dualpivot_swap(container, k, less)
                less += 1
              end
            end
          end
        end
        # subarray
        if pivot1 < pivot2
          dualpivot(container, less, great, div)
        end
        container
      end
    end

    def self.dualpivot_swap(container, i, j)
      container[i],  container[j] = container[j],  container[i]
    end
  end
end
