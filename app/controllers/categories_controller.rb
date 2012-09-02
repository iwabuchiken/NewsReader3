require 'utils'

class CategoriesController < ApplicationController
  
  layout 'admin'
  
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    
    category = params[:category]
    category_name = category['name']
    
    write_log("category.to_s: #{category.to_s}",
                __FILE__.split("/")[-1],
                __LINE__.to_s)
    
    cats = []
    if category_name != nil
      cats = category_name.split(" ")
    end
    
    write_log("cats.size: #{cats.size}",
                __FILE__.split("/")[-1],
                __LINE__.to_s)

    if cats.size > 1
      
      flag = true
      counter = 0
      
      cats.each do |cat|
        # @category = Category.new(params[:category])
        # @category = Category.new(name=cat)
        @category = Category.new({"name"=> cat, "genre_id"=> category['genre_id']})
        
        if @category.save
        else
          counter += 1
        end
      end#cats.each do |cat|
      
      respond_to do |format|
          format.html { redirect_to @category, 
                          notice: "New categories: Created => #{cats.size - counter}, Failed => #{counter}" }
          format.json { render json: @category, status: :created, location: @category }
      end
      
    else#if cats.size > 1
        @category = Category.new(params[:category])
    
        respond_to do |format|
          if @category.save
            format.html { redirect_to @category, notice: 'Category was successfully created.' }
            format.json { render json: @category, status: :created, location: @category }
          else
            format.html { render action: "new" }
            format.json { render json: @category.errors, status: :unprocessable_entity }
          end
        end
    end#if cats.size > 1
    
    
    # @category = Category.new(params[:category])
# 
    # respond_to do |format|
      # if @category.save
        # format.html { redirect_to @category, notice: 'Category was successfully created.' }
        # format.json { render json: @category, status: :created, location: @category }
      # else
        # format.html { render action: "new" }
        # format.json { render json: @category.errors, status: :unprocessable_entity }
      # end
    # end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end
end
