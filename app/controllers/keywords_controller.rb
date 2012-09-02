class KeywordsController < ApplicationController
  
  layout 'admin'
  
  # GET /keywords
  # GET /keywords.json
  def index
    @keywords = Keyword.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @keywords }
    end
  end

  # GET /keywords/1
  # GET /keywords/1.json
  def show
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @keyword }
    end
  end

  # GET /keywords/new
  # GET /keywords/new.json
  def new
    @keyword = Keyword.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @keyword }
    end
  end

  # GET /keywords/1/edit
  def edit
    @keyword = Keyword.find(params[:id])
  end

  # POST /keywords
  # POST /keywords.json
  def create
    create_v1()
    # @keyword = Keyword.new(params[:keyword])
# 
    # respond_to do |format|
      # if @keyword.save
        # format.html { redirect_to @keyword, notice: 'Keyword was successfully created.' }
        # format.json { render json: @keyword, status: :created, location: @keyword }
      # else
        # format.html { render action: "new" }
        # format.json { render json: @keyword.errors, status: :unprocessable_entity }
      # end
    # end
  end
  
  # PUT /keywords/1
  # PUT /keywords/1.json
  def update
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      if @keyword.update_attributes(params[:keyword])
        format.html { redirect_to @keyword, notice: 'Keyword was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.json
  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy

    respond_to do |format|
      format.html { redirect_to keywords_url }
      format.json { head :no_content }
    end
  end
  
  private #=========================================
  def create_v1()
    
    keyword = params[:keyword]
    keyword_name = keyword['name']
    
    write_log("keyword.to_s: #{keyword.to_s}",
                __FILE__.split("/")[-1],
                __LINE__.to_s)
    
    keywords = []
    if keyword_name != nil
      keywords = keyword_name.split(" ")
    end
    
    write_log("keywords.size: #{keywords.size}",
                __FILE__.split("/")[-1],
                __LINE__.to_s)

    if keywords.size > 1
      
      flag = true
      counter = 0
      
      keywords.each do |kw|
        # @category = Category.new(params[:category])
        # @category = Category.new(name=cat)
        @keyword = Keyword.new({"name"=> kw, "category_id"=> keyword['category_id']})
        
        if @keyword.save
        else
          counter += 1
        end
      end#cats.each do |cat|
      
      respond_to do |format|
          format.html { redirect_to @keyword, 
                          notice: "New keywords: Created => #{keywords.size - counter}, Failed => #{counter}" }
          format.json { render json: @keyword, status: :created, location: @keyword }
      end
      
    else#if cats.size > 1
        @keyword = Keyword.new(params[:keyword])
    
        respond_to do |format|
          if @keyword.save
            format.html { redirect_to @keyword, notice: 'Keyword was successfully created.' }
            format.json { render json: @keyword, status: :created, location: @keyword }
          else
            format.html { render action: "new" }
            format.json { render json: @keyword.errors, status: :unprocessable_entity }
          end
        end
    end#if cats.size > 1

    
  end#create_v1()
  
  
end


