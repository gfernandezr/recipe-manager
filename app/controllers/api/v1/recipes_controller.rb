module Api
  module V1
    class RecipesController < BaseController
      before_action :set_recipe, only: [:show, :update, :destroy, :update_image]
      
      # GET /api/v1/recipes
      def index
        @recipes = Recipe.all
                         .search(params[:q])
                         .by_difficulty(params[:difficulty])
                         .by_cook_time(params[:max_cook_time])
                         .by_category(params[:category_id])
                         .by_rating(params[:rating])
                         .page(params[:page]).per(params[:per_page] || 10)
        
        # Set up serialization context for pagination
        serialization_context = ActiveModelSerializers::SerializationContext.new(request)
        options = {}
        options[:meta] = pagination_meta(@recipes)
        options[:serialization_context] = serialization_context
        
        render json: @recipes, 
               each_serializer: RecipeSerializer,
               adapter: :json_api,
               meta: options[:meta],
               meta_key: :meta
      end
      
      # GET /api/v1/recipes/1
      def show
        render json: @recipe, serializer: RecipeDetailSerializer
      end
      
      # POST /api/v1/recipes
      def create
        @recipe = Recipe.new(recipe_params)
        
        if @recipe.save
          attach_image if params[:image].present?
          render json: @recipe, status: :created, location: api_v1_recipe_url(@recipe)
        else
          render_errors(@recipe)
        end
      end
      
      # PATCH/PUT /api/v1/recipes/1
      def update
        if @recipe.update(recipe_params)
          attach_image if params[:image].present?
          render json: @recipe
        else
          render_errors(@recipe)
        end
      end
      
      # PATCH /api/v1/recipes/1/image
      def update_image
        if params[:image].present? && @recipe.image.attach(params[:image])
          render json: @recipe, serializer: RecipeSerializer
        else
          render json: { error: 'Failed to update image' }, status: :unprocessable_entity
        end
      end
      
      # DELETE /api/v1/recipes/1
      def destroy
        @recipe.destroy
        head :no_content
      end
      
      private
      
      def set_recipe
        @recipe = Recipe.find(params[:id])
      end
      
      def recipe_params
        recipe_params = params.require(:recipe).permit(
          :title, :description, :prep_time, :cook_time, :servings, :difficulty, :rating,
          category_ids: [],
          ingredients: [],
          instructions: []
        )
        
        # Convert arrays to newline-separated strings if they are arrays
        [:ingredients, :instructions].each do |field|
          if recipe_params[field].is_a?(Array)
            recipe_params[field] = recipe_params[field].reject(&:blank?).join("\n")
          end
        end
        
        recipe_params
      end
      
      def attach_image
        @recipe.image.attach(params[:image]) if params[:image].is_a?(ActionDispatch::Http::UploadedFile)
      end
      
      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
