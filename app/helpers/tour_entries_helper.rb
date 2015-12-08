module TourEntriesHelper
  def colour_picker(sum)
    return if sum == 0
    if sum < 0
      return '#FFDBEE'
    else
      return '#DEFAD4'
    end
  end
end