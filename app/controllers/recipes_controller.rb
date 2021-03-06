class RecipesController < ApplicationController
    
    before_action :find_category, only: [:index, :new, :create]
    before_action :find_recipe, only: [:show, :edit, :update, :destroy ]
    layout "recipes_layout"  
   
    def index
      if @category
         @recipe = @category.recipe
      else
       @recipes = Recipe.all.alphabetize    
      end
      if @comment 
         @recipes = @comment.recipes
       end
   end

   def show
      if @category
         redirect_to category_recipe_path(@category) 
       end 
       if @comment
         redirect_to recipe_path(@recipe)
       end
   end

   def new
      if @category
         @recipe = @category.recipe.new
         render :new_category_recipe
      else
         @recipe = Recipe.new

         @recipe.ingredients.new(name: "")
             
         @recipe.directions.new(step: "")
      end
   end

   def create
         @recipe = Recipe.new(recipe_params)
      if @recipe.save
         #if valid
         if @category
            redirect_to category_recipe_path(@category)
         else   
            redirect_to recipes_path
         end
      else
         #if not valid
         flash.now[:error] = @recipe.errors.full_messages
         
         if @category
            render :new_category_recipe_path
         else
            render :new
         end
      end
   end

   def edit       
   end

   def update
      if @recipe.update(recipe_params)
         redirect_to recipe_path(@recipe)
      else 
          flash.now[:error] = @recipe.errors.full_messages
          render :edit
      end
   end 

   def destroy
      @recipe.destroy
      flash[:notice] = "#{@recipe.title} was deleted"
      redirect_to recipes_path           
   end

   private
   
   def find_recipe
      @recipe = Recipe.find(params[:id])
    end

    def find_category
      if params[:category_id]
        @category = Category.find_by_id(params[:category_id])
      end
    end

   def recipe_params
      params.require(:recipe).permit(
       :title,
       :description,
       :category_id,
       category_attributes: [:name],
       ingredients_attributes: [:id, :name, :quantity, :_destroy],
       directions_attributes: [:id, :step, :_destroy]
    )       
   end

end