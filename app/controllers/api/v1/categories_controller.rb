module Api
  module V1
    class CategoriesController < BaseController
      before_action :set_category, only: [:show, :update, :destroy]
      
      # GET /api/v1/categories
      def index
        @categories = Category.alphabetical
        render json: @categories, each_serializer: CategorySerializer
      end
      
      # GET /api/v1/categories/1
      def show
        render json: @category, serializer: CategorySerializer
      end
      
      # POST /api/v1/categories
      def create
        @category = Category.new(category_params)
        
        if @category.save
          render json: @category, status: :created, location: api_v1_category_url(@category)
        else
          render_errors(@category)
        end
      end
      
      # PATCH/PUT /api/v1/categories/1
      def update
        if @category.update(category_params)
          render json: @category
        else
          render_errors(@category)
        end
      end
      
      # DELETE /api/v1/categories/1
      def destroy
        if @category.recipes_count.positive?
          @category.errors.add(:base, 'Cannot delete category with associated recipes')
          render_errors(@category)
        else
          @category.destroy
          head :no_content
        end
      end
      
      private
      
      def set_category
        @category = Category.find(params[:id])
      end
      
      def category_params
        params.require(:category).permit(:name, :color)
      end
    end
  end
end
