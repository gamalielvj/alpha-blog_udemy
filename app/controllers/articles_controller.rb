class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  
  def index
    #@articles = Article.all
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @article = Article.new
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def create
   #render plain: params[:article].inspect
   
   #debugger
   
   @article = Article.new(article_params)
   
   # Asignar Usuario al articulo creado
   @article.user = User.first
   
   if @article.save
    flash[:success] = "Article was sucessfully created"
    redirect_to article_path(@article)
   else
     render 'new'
   end
   
  end
  
  def update
    
    if @article.update(article_params)
      flash[:success] = "Article was sucessfully updated"
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end
  
  
  
  def show
    
  end
  
  def destroy
    
    @article.destroy
    flash[:danger] = "Article was successfully deleted"
    redirect_to articles_path
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end
  
  def article_params
    params.require(:article).permit(:title, :description)
  end
end