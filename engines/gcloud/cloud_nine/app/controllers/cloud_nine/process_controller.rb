module CloudNine
  class ProcessController < ApplicationController
    before_action :set_view_paths

    private

      def set_view_paths
        prepend_view_path "/Projects/autoshop/engines/cloud_nine/app/views"
      end
  end
end



# class SomeController < ApplicationController
#   before_action :set_view_paths
#
#   private
#
#   def set_view_paths
#     prepend_view_path "/Projects/autoshop/engines/cloud_nine/app/views"
#   end
# end
