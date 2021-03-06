class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :favorite]
  def index
    products = Product.all

    if sort_params.present?
      @category = Category.request_category(sort_params[:sort_category])
      products = products.sort_products(sort_params, params[:page]).where(notdisplay_flag: false).order(created_at: "desc")
    end

    if params[:category].present?
      @category = Category.request_category(params[:category])
      products = products.category_products(@category, params[:page]).where(notdisplay_flag: false).order(created_at: "desc")
      
    end
    
    products = products.where('name LIKE ?', "%#{params[:keyword]}%") if params[:keyword].present?

    @products = products.display_list(params[:page]).where(notdisplay_flag: false).order(created_at: "desc")
    @keyword = params[:keyword];
    @major_categories = MajorCategory.all #
    @categories = Category.all
    @sort_list = Product.sort_list
  end

  def show
    @reviews = @product.reviews_with_id
    @review = @reviews.new
    @star_repeat_select = Review.star_repeat_select
    @major_categories = MajorCategory.all #
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_url
  end
  
  def favorite
    current_user.toggle_like!(@product)
    redirect_to product_url @product
  end
  
  private
    def set_product
      @product = Product.find(params[:id])
    end
    
    def product_params
      params.require(:product).permit(:name, :description, :price, :category_id)
    end
    
    def sort_params
      params.permit(:sort, :sort_category)
    end
end
