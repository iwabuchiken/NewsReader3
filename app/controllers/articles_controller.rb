#coding:utf-8

require 'nokogiri'
require 'open-uri'

require 'basics'
include BASICS

require 'utils'
# load 'utils'

class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
      #------------------------------
      # 1. Get number of docs
      # 2. Set genre
      # 3. Get objects
      # 3-2. Set "@genres"
      
      # 4. Set session objects
      #------------------------------
      #------------------------------
      # 1. Get number of docs
      #------------------------------
      number = get_num_of_docs()
      
      #----------------------
      # 2. Set genre
      #----------------------
      @genre = get_genre()

      #debug
      write_log(
                "genre=" + @genre,  
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)


      
      #----------------------
      # 3. Get objects
      #----------------------
      #//----------- try_3 -----------------
      @current_num = number
      
      @params = params

      # #debug
      # params_content = ""
#       
      # params.each_pair {|k, v|
#         
        # params_content += "(" + k + "=>" + v + ")"
#         
      # }
#       
      # write_log(
                # "params_content=" + params_content,  
                # # __FILE__,
                # __FILE__.split("/")[-1],
                # __LINE__.to_s)      
# 


      @kw = []
      
      if @genre == "int"
          
          @category_names = _get_category_names_int()

          write_log(
                "@category_names.size=" + @category_names.size.to_s,  
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)      

          @kw = set_category_names_and_keywords_int()
          
          # #debug
          # msg = ""
          # @kw[0].each {|k|
              # msg += k + "/"
          # }
#           
#           
          # write_log(
                # msg,  
                # # __FILE__,
                # __FILE__.split("/")[-1],
                # __LINE__.to_s)
#                               => 米国/米/アメリカ/ 
                      
      elsif @genre == "bus_all"
        
        set_category_names_and_keywords_bus()
        

      elsif @genre == "soci"
        
        set_category_names_and_keywords_soci()
        

        
      else 
        @category_names = ["All"]
      end
#       

      @objects = try_3(number, @genre)
      
      genres_src = Genre.all
      
      @genres = {}
      genres_src.each do |item|
        @genres[item.name] = item.code
      end
      

      #----------------------
      # 4. Set session objects
      #----------------------
      # REF => 黒田・佐藤：322
      session[:doc_num] = @current_num
      
      session[:genre] = @genre

  end#def index

  def _get_category_names_int()
    
      genre = Genre.find_by_code("int")
        
      write_log(
              "genre.name =>" + genre.name, 
              # __FILE__,
              __FILE__.split("/")[-1],
              __LINE__.to_s)
      
      if genre != nil
        
        categories = Category.find_all_by_genre_id(genre.id)
        
        write_log(
              "genre != nil => #{genre.name}", 
              # __FILE__,
              __FILE__.split("/")[-1],
              __LINE__.to_s)
        
        #debug
        if categories != nil
          
            write_log(
              "categories.size=" + categories.size.to_s, 
              # __FILE__,
              __FILE__.split("/")[-1],
              __LINE__.to_s)

              
        else
          
            write_log(
                "categories => nil", 
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)
          
        end
        
        
      else
        
        write_log(
              "genre == nil", 
              # __FILE__,
              __FILE__.split("/")[-1],
              __LINE__.to_s)


        
        # render :text "Genre wasn't found by the code 'int'"
        
      end
      
      # categories = Category.find_all_by_genre_id(3)
      
      category_names = []
      
      categories.each do |cat|
        
          category_names.append(cat.name)
        
      end
      
      category_names.append("Others")
      
      #debug
      write_log(
                "category_names.size=" + category_names.size.to_s, 
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)
        
      
      return category_names
      
  end#def _get_category_names_int()

  def set_category_names_and_keywords_soci
    
        @category_names = [
                              #"原発", "事件", "政治"
                              "Nuclear plants", "Incidents", "Political issues",
                              "韓国", "中国", "医療/介護", "災害", "Others"
                              ]
        
        # @kw[0] = ["原発", "福島", "", "東電", "東京電力", "原子力"]
        @kw[0] = ["原発", "福島", "東電", "東京電力", "原子力"] 
        
        # Incidents
        @kw[1] = ["殺人", "傷害", "盗撮", "事件", "逮捕", "いじめ", "女性"]
        
        @kw[2] = ["首相", "市長", "選挙"]
        
        @kw[3] = ["韓国", "竹島"]
        
        # 中国
        @kw[4] = ["中国", "尖閣", "日中"]
        
        # 医療/介護
        @kw[5] = ["介護", "がん", "感染", "食中毒", "けが", "出生", "風邪", "妊娠"]
        
        # 災害
        @kw[6] = ["防災", "高温", "津波"]    
    
  end#def set_category_names_and_keywords_soci

  def set_category_names_and_keywords_bus
        @category_names = [
                          "US", "China", "Europe", 
                          "Korea", "Middle east",
                          "Japan: Automobile",
                          "Japan: Electronics", 
                          "Energy",
                          "Securities, foreign exchanges",
                          "Others"]
        
        @kw[0] = ["米国", "米", "アメリカ"]
      
        @kw[1] = ["中国", "中"]
        
        @kw[2] = [
                        "ヨーロッパ", "欧州", "欧", "EURIBOR", "EURO", "ユーロ", 
                        "ロシア", "東欧", "ポーランド", 
                        "イギリス", "フランス", "ドイツ", 
                        "スペイン", "イタリア", "伊", "ポルトガル", 
                        ]
        
        @kw[3] = [
                        "韓国", "韓", "朝鮮",
                        "サムスン", "現代"
                        ]
        
        @kw[4] = ["イラン", "シリア", "イラク"]
        
        @kw[5] = [
                        "自動車", "乗用車",
                        "日産", "日野", "三菱自", "トヨタ", "ダイハツ", "ホンダ", "マツダ",
                        "ＢＭＷ", "BMW", "ベンツ"
                        ]
        
        @kw[6] = [
                          "ソニー", "パナソニック", "松下", "シャープ", "東芝", "三菱電",
                          "セイコー"
                          
                          ]
        
        @kw[7] = ["ガソリン", "ソーラー", "原油", "原発", "石油", "エネルギー", "発電", "火力"]
        
        @kw[8] = ["証券", "相場", "円", "日経平均", "ＥＵＲＩＢＯＲ"]
        
  end#def set_category_names_and_keywords_bus
  
  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
  
  private #==========================================
    # ============ try_1 => From: try_nokogiri_17 ========================
  def get_atags(docs)
  #    # Get doc
  #    docs = get_docs(5)
  #    
  #    #meta_tags
  #    meta_tags = nil
  #    
  #    # New docs
  #    docs_new = []
  
      # href a tags
      a_tags_href = []
      
      vendor_list = []
      
      # #debug
      # get_next_sibling = true
      
      # Modify
      docs.each do |doc|
        #--------------------
        # Modify 'a' tags
        #--------------------
        
        # Get 'a' tags
        a_tags = doc.css("div ul li a")
        
        # href value
        a_tags.each do |a_tag|
          if a_tag['href'].start_with?("/hl?")
            # Modify url
            a_tag['href'] = "http://headlines.yahoo.co.jp" + a_tag['href']
            
            # Add
            a_tags_href.push(a_tag)
            
            # #debug =================================
            # #debug
            
            # # REF http://nokogiri.rubyforge.org/nokogiri/Nokogiri/XML/Node.html
            # ns = a_tag.next_sibling
# #             
            # if get_next_sibling
# #               
                # # while (ns) do
# #                     
                    # # if ns.next_sibling != "写真"
                        # write_log(
                                  # "a_tag.next_sibling=" + a_tag.next_sibling,  
                                  # # "a_tag.content=" + a_tag.content,  
                                  # # __FILE__,
                                  # __FILE__.split("/")[-1],
                                  # __LINE__.to_s)
                        # # break
# #                         
                    # # end
# #                     
                    # # ns = ns.next_sibling
                # # end
#                 
                # get_next_sibling = false
#                 
            # end#if get_next_sibling
                # while (ns) do
#                   
                    # if(ns['href'] && ns['href'].start_with?("http::"))
#                       
                        # write_log(
                            # "ns.content=" + ns.content,  
                            # # __FILE__,
                            # __FILE__.split("/")[-1],
                            # __LINE__.to_s)
#                         
                        # break
#                       
                    # end
#                   
                    # ns = ns.next_sibling
#                   
                # end
#                 
                # get_next_sibling = false
#               
            # end
#             
            # # vendor = a_tag.next_sibling.next_sibling.next_sibling
#             
            # # if a_tag.next_sibling != nil
                # # vendor_list << vendor.text
            # # end
#             
#             
            # #/========================================
            
          end#if a_tag['href'].start_with?("/hl?")
        end#a_tags.each do |a_tag|
  
        
  #      # New doc
  #      docs_new.push(a_tags_href)
        
        #----------------------
        # Vendor list
        # 
        
        
        # a_tags.each do |a_tag|
#           
            # if a_tag['href'].start_with?("http://headlines.yahoo.co.jp/list")
#               
                # vendor_list << a_tag.text
#               
              # # # Modify url
              # # a_tag['href'] = "http://headlines.yahoo.co.jp" + a_tag['href']
  # #             
              # # # Add
              # # a_tags_href.push(a_tag)
#               
            # end#if a_tag['href'].start_with?("/hl?")
#             
        # end#a_tags.each do |a_tag|
        #--------------------
        # Modify 'charset' value
        #--------------------
        
      end#docs.each do |doc|
  
      #debug
      write_log(
                  "vendor_list.size=" + vendor_list.size.to_s +
                  "/" + "a_tags_href.size=" + a_tags_href.size.to_s,
                  # __FILE__,
                  __FILE__.split("/")[-1],
                  __LINE__.to_s)
  
  
      # Return
      return a_tags_href
    
  end#def get_atags

  def get_docs(number, genre="soci")
        # Get params
    # genre = params['genre']
    
    # Urls
    url = "http://headlines.yahoo.co.jp/hl?c=#{genre}&t=l&p="
    
    # if genre != nil
      # # url = "http://headlines.yahoo.co.jp/hl?c=soci&t=l&p="
      # url = "http://headlines.yahoo.co.jp/hl?c=#{genre}&t=l&p="
    # else
      # url = "http://headlines.yahoo.co.jp/hl?c=soci&t=l&p="
    # end
    
    # HTML docs
    docs = []
    
    # Thread array
    threads = []
    
    # Get docs
    # 2.times do |i|
    number.times do |i|
      # Get docs
      threads << Thread.start(i, url) do
        # puts "Thred #{i.to_s}: " + urls[i] 
        # docs[i] = Nokogiri::HTML(open(urls[i]))
        docs[i] = Nokogiri::HTML(open(url + (i + 1).to_s))
      end
    
      # Join
      threads.each do |t|
        t.join
      end
    end
    
    # Return
    return docs

  end#def get_docs(number)

    
  def categorize_try17_others(a_tags)
    #######################
    # Steps
    # 1. 
    
    
    #######################
    # 1.
    cat_usa = []; cat_china = [];
    cat_europe = []; cat_others = [];
    
    # 
    a_tags_categorized = []
    
    #
    #kw_usa = ["アメリカ", "米国", "米"] 
    kw_usa = ["アメリカ", "米国", "米"]
    # kw_usa = [u"アメリカ", u"米国", u"米"]gs.each do |a_tag|
    
    kw_china = ["中国"]
    
    kw_europe = ["ヨーロッパ", "欧州", "フランス", "ドイツ", "イギリス", "欧", "EU", "ギリシャ"]
    
    #
    a_tags.each do |a_tag|
      # Flag
      is_in = false
      
      #
      kw_usa.each do |word|
        #
        if a_tag.content.include?(word)
          cat_usa.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_usa.each do |word|
        # else

      #
      kw_china.each do |word|
        #
        if a_tag.content.include?(word)
          cat_china.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_usa.each do |word|

      #
      kw_europe.each do |word|
        #
        if a_tag.content.include?(word)
          cat_europe.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_europe.each do |word|

      #
      if is_in == false
        cat_others.push(a_tag)
      end#if is_in == false
          
        # end#if a_tag.content.include?(word)
      # end#kw_usa.each do |word|
    end#a_tags.each do |a_tag|
      
    # Return
    return [cat_usa, cat_china, cat_europe, cat_others]    
  end#def categorize_try17_others(a_tags)

  def categorize_try17_bus(a_tags)
    #######################
    # Steps
    # 1. Categories
    # 2. Key words
    # 3. Array of arrays
    # 4. a_tags_categorized
    # 5. Categorize
    # 6. Return
    #######################
    
    #######################
    # 1. Categories
    #######################
    cat_usa = []; cat_china_taiwan = []; cat_europe = []
    cat_tax = []; cat_nuc_plants = []; cat_enterprises = [];
    cat_economy = []; cat_others = []
    
    # #
    # cats = [cat_usa, cat_china_taiwan, cat_europe,
            # cat_tax, cat_nuc_plants, cat_enterprises,
            # cat_economy, cat_others]
    
    #######################
    # 2. Key words
    #######################
    #
    kw_usa = [
            # Country
            "アメリカ", "米国", "米",
            
            # Cities
            "ニューヨーク",
            
            ] 
    #kw_nuc_plants = ["原発", "原子力", "原子力発電所"]
    # kw_usa = [u"アメリカ", u"米国", u"米"]gs.each do |a_tag|
    
    kw_china_taiwan = ["中国", "台湾"]
    
    kw_europe = [
            # Countries
            "フランス", "ドイツ", "イギリス", "ギリシャ", "ロシア", "イタリア",
            "スペイン", "ポルトガル", "キプロス",
            "独", "仏", "英", "伊", "露",
            
            # Cities
            "ベルリン", "パリ", "ロンドン", "モスクワ",
            
            # Regions
            "欧", "欧州", "ヨーロッパ", "EU", "ユーロ", "西欧", "東欧", "北欧" 
            ]
    
    kw_tax = ["税", "税金", "消費税", "脱税"]
    
    kw_nuc_plants = ["原発", "原子力", "原子力発電所", "東電", "東京電力", "関電"]
    
    kw_enterprises = [
                  "企業", "会社",
                  
                  # Companies
                  "ソニー", "パナ", "パナソニック", "シャープ", "日興證券", 
                  "日興", "東レ",
                  
                  # Others
                  "社内", "社外",
                  ]
    
    kw_economy = [
                # Macro
                "経済", "景気", "所得", "国民",
                
                # Industries
                "エネルギー", "石油", "再生",
                ]
    
    
    #######################
    # 3. Array of arrays
    #######################
    # Key words
    kws = [kw_usa, kw_china_taiwan, kw_europe,
            kw_tax, kw_nuc_plants, kw_enterprises, kw_economy]
            
    # Categories
        #
    cats = [cat_usa, cat_china_taiwan, cat_europe,
            cat_tax, cat_nuc_plants, cat_enterprises,
            cat_economy, cat_others]

    #######################
    # 4. a_tags_categorized
    #######################
    a_tags_categorized = []
    

    #######################
    # 5. Categorize
    #######################
    #
    a_tags.each do |a_tag|
      # Flag
      is_in = false

      #
      kws.length.times do |i|
        #
        kws[i].each do |word|
          #
          if a_tag.content.include?(word)
            cats[i].push(a_tag)
            
            #
            is_in = true
            
            break
          
          end#if a_tag.content.include?(word)
          
        end#kws[i].each do |word|
        
      end#kws.length.times do |i|

      if is_in == false
        cat_others.push(a_tag)
      end#if is_in == false
      
    end#a_tags.each do |a_tag|
    
    #######################
    # 6. Return
    #######################
    return cats
    
    # return [cat_nuc_plants, cat_china_taiwan, 
              # cat_tax, cat_osaka, cat_enterprises, 
              # cat_incidents,cat_others]

  end#def categorize_try17_bus(a_tags)

  def categorize_try17_society(a_tags)
    #######################
    # Steps
    # 1. 
    
    
    #######################
    # 1.
    cat_nuc_plants = []; cat_china_taiwan = [];
    cat_tax = []; cat_osaka = []; cat_enterprises = [];
    cat_incidents = []; cat_others = []
    
    # 
    a_tags_categorized = []
    
    #
    #kw_usa = ["アメリカ", "米国", "米"] 
    kw_nuc_plants = ["原発", "原子力", "原子力発電所"]
    # kw_usa = [u"アメリカ", u"米国", u"米"]gs.each do |a_tag|
    
    kw_china_taiwan = ["中国", "台湾"]
    
    kw_tax = ["税", "税金", "消費税", "脱税"]
    
    kw_osaka = ["大阪", "橋下", "阪神", "関西"]
    
    kw_enterprises = ["企業", "会社", "ソニー", "パナ", 
                      "パナソニック", "シャープ", "社内", "社外",
                      "日興證券", "日興"]
    
    kw_incidents = ["逮捕", "事件", "犯罪", "犯", "罪", 
                     "虐待", "暴行", "傷害", "遺棄"]
    
    #
    a_tags.each do |a_tag|
      # Flag
      is_in = false
      
      #
      kw_nuc_plants.each do |word|
        #
        if a_tag.content.include?(word)
          cat_nuc_plants.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_nuc_plants.each do |word|

      #
      kw_china_taiwan.each do |word|
        #
        if a_tag.content.include?(word)
          cat_china_taiwan.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_china_taiwan.each do |word|

      #
      kw_tax.each do |word|
        #
        if a_tag.content.include?(word)
          cat_tax.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_tax.each do |word|

      #
      kw_osaka.each do |word|
        #
        if a_tag.content.include?(word)
          cat_osaka.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_osaka.each do |word|

      #
      kw_enterprises.each do |word|
        #
        if a_tag.content.include?(word)
          cat_enterprises.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_enterprises.each do |word|

      #
      kw_incidents.each do |word|
        #
        if a_tag.content.include?(word)
          cat_incidents.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_incidents.each do |word|

      #
      if is_in == false
        cat_others.push(a_tag)
      end#if is_in == false
          
        # end#if a_tag.content.include?(word)
      # end#kw_usa.each do |word|
    end#a_tags.each do |a_tag|
    
    # Return
    return [cat_nuc_plants, cat_china_taiwan, 
              cat_tax, cat_osaka, cat_enterprises, 
              cat_incidents,cat_others]

  end#def categorize_try17_others(a_tags)
  
  def categorize_try17_overseas(a_tags)
    #######################
    # Steps
    # 1. 
    
    
    #######################
    # 1.
    cat_usa = []; cat_china = [];
    cat_europe = []; cat_korea = [];
    cat_me = []; cat_india = []
    cat_others = [];
    
    # 
    a_tags_categorized = []
    
    #
    kw_usa = ["アメリカ", "米国", "米"] 
    # kw_usa = [u"アメリカ", u"米国", u"米"]gs.each do |a_tag|
    
    kw_china = ["中国"]
    
    kw_europe = [
            # Countries
            "フランス", "ドイツ", "イギリス", "ギリシャ", "ロシア", "イタリア",
            "独", "仏", "英", "伊", "露",
            # Cities
            "ベルリン", "パリ", "ロンドン", "モスクワ",
            # Europe
            "欧", "欧州", "ヨーロッパ", "EU", "ユーロ" 
            ]
    
    kw_korea = [
            # Countries, Regions
            "韓国", "韓", "朝鮮",
            # Cities
            "ソウル", "ピョンヤン", "平城"
            ]
    
    kw_me = ["中東", 
              # Countries
              "シリア", "ヨルダン", "イラク", "イラン", "エジプト",
              "イスラエル",
              # Groups
              "ハマス"
              ]
    
    kw_india = ["インド"]
    
    #
    a_tags.each do |a_tag|
      #=============================
      # 1. USA
      # 2. China
      # 3. Europe
      # 4. Korea
      # 5. Middle East
      # 6. India
      # 0. Others
      #=============================
      # Flag
      is_in = false
      
      #
      kw_usa.each do |word|
        #
        if a_tag.content.include?(word)
          cat_usa.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_usa.each do |word|
        # else

      #===================
      # 2. China
      #===================
      kw_china.each do |word|
        #
        if a_tag.content.include?(word)
          cat_china.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_usa.each do |word|

      #===================
      # 3. Europe
      #===================
      kw_europe.each do |word|
        #
        if a_tag.content.include?(word)
          cat_europe.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_europe.each do |word|

      #===================
      # 4. Korea
      #===================
      kw_korea.each do |word|
        #
        if a_tag.content.include?(word)
          cat_korea.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_europe.each do |word|

      #===================
      # 5. Middle East
      #===================
      kw_me.each do |word|
        #
        if a_tag.content.include?(word)
          cat_me.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_europe.each do |word|

      #===================
      # 6. India
      #===================
      kw_india.each do |word|
        #
        if a_tag.content.include?(word) \
            and not a_tag.content.include?("インドネシア")
          cat_india.push(a_tag)
          
          #
          is_in = true
          break
          
        end#if a_tag.content.include?(word)
          
      end#kw_europe.each do |word|

      #===================
      # 
      #===================
      if is_in == false
        cat_others.push(a_tag)
      end#if is_in == false
          
        # end#if a_tag.content.include?(word)
      # end#kw_usa.each do |word|
    end#a_tags.each do |a_tag|
      
    # Return
    return [cat_usa, cat_china, cat_europe, 
              cat_korea, cat_me, cat_india,
              cat_others]    
  end#def categorize_overseas(a_tags)

  def categorize_try17(a_tags)
    #######################
    # Steps
    # 1. 
    
    
    #######################
    # Param
    @genre = params['genre']

    # Switching
    if @genre == "int"
      a_tags_categorized = categorize_try17_overseas(a_tags)
    elsif @genre == "soci"
      a_tags_categorized = categorize_try17_society(a_tags)
    elsif @genre == "bus_all"
      a_tags_categorized = categorize_try17_bus(a_tags)
    else
      a_tags_categorized = categorize_try17_others(a_tags)
    end
    
    # Return
    return a_tags_categorized
    
  end#def categorize_try17(a_tags)

  def try_1(doc_num=3, genre="soci")
    ###########################
    # Steps
    # 1. Get categories
    # 2. Get docs
    # 3. Get a_tags    
    ###########################
    
    #=====================
    # 1. Get categories
    #=====================
    # Param

    # Switch
    
    #=====================
    # 2. Get docs
    #=====================
    # Get doc
    # docs = get_docs(5)
    # docs = get_docs(doc_num)
    docs = get_docs(doc_num, genre)

    #=====================
    # 3. Get a_tags
    #=====================
    a_tags = get_atags(docs)
    
    
    # Categorize
    
    # Return
    # return a_tags
    return a_tags
    
    #debug
#    return meta_tags
    
#    
    # return docs
    # return docs_new
    
  end#def try_1

  #--------- try_2 --------------------------------------------
  def categorize(a_tags)
      #==========================
      # Steps
      # 1. 
      
      #==========================
      len = a_tags.size
      
      return [a_tags[0..(len/2)], a_tags[(len/2)..len]]
      
    
  end#def categorize(a_tags)
  
  def try_2(doc_num=3, genre="soci")
    ###########################
    # Steps
    # 1. Get categories
    # 2. Get docs
    # 3. Get a_tags
    # 4. Categorize
    # 9. Return tags     
    ###########################
    
    #=====================
    # 1. Get categories
    #=====================
    # Param

    # Switch
    
    #=====================
    # 2. Get docs
    #=====================
    docs = get_docs(doc_num, genre)

    #=====================
    # 3. Get a_tags
    #=====================
    a_tags = get_atags(docs)

    #----------------------    
    # 4. Categorize
    #----------------------
    categories = categorize(a_tags)
    
    #----------------------
    # 9. Return tags
    #----------------------
    return categories
    # return a_tags
    
  end#def try_2

  #--------- try_3 --------------------------------------------
  # def write_log(text, file, line)
#     
    # f = open("log.log", "a")
#     
    # # f.write("[#{get_time_label_now()}]" + line + ": " + text)
    # f.write("[#{get_time_label_now()}] [#{file}: #{line}] #{text}")
#     
    # f.write("\n")
#     
    # f.close
#     
  # end#def write_log()
  
  # def get_time_label_now()
#     
    # return Time.now.strftime("%Y%m%d_%H%M%S")
#     
  # end#def get_time_label_now()
  
  def set_category_names_and_keywords_int()
        
        kw = []
        
        kw[0] = _kw_US()
        
        # category = Category.find_by_name("US")
#         
        # if category != nil
#           
            # write_log(
                  # "category.name=" + category.name, 
                  # # __FILE__,
                  # __FILE__.split("/")[-1],
                  # __LINE__.to_s)
# 
#             
            # kws = Keyword.find_all_by_category_id(category.id)
# 
            # write_log(
                  # "kws.size=" + kws.size.to_s, 
                  # # __FILE__,
                  # __FILE__.split("/")[-1],
                  # __LINE__.to_s)
# 
#                   
            # kw[0] = []
#             
            # # Set keywords
            # if (kws == nil) or (kws.size == 0)
#                 
                # kw[0] = ["米国", "米", "アメリカ"]
#                 
            # else
#               
                # kws.each do |kw|
#                   
                  # kw[0].append(kw.name)
#                   
                # end
#               
            # end
#             
        # else
#           
          # kw[0] = ["米国", "米", "アメリカ"]
#           
        # end
        
        
        # @kw[0] = ["米国", "米", "アメリカ"]    
        
      
        kw[1] = ["中国", "中"]
        
        kw[2] = ["ヨーロッパ", "欧州", "欧", "ロシア", "イギリス", "フランス"]
        
        kw[3] = ["韓国", "韓", "朝鮮"]
        
        kw[4] = ["イラン", "シリア", "イラク"]
        
        return kw
    
  end#def set_category_names_and_keywords_int()

  def _kw_US
      category = Category.find_by_name("US")
        
      if category != nil
        
          write_log(
                "category.name=" + category.name, 
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)

          
          kws = Keyword.find_all_by_category_id(category.id)

          write_log(
                "kws.size=" + kws.size.to_s, 
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)

                
          kw = []
          
          # Set keywords
          if (kws == nil) or (kws.size == 0)
              
              kw = ["米国", "米", "アメリカ"]
              
          else
            
              kws.each do |word|
                
                kw.append(word.name)
                
              end
            
          end
          
      else
        
        kw = ["米国", "米", "アメリカ"]
        
      end#if category != nil
      
      return kw
      
  end#def _kw_US
    
  def get_num_of_docs()
    
      if params['doc_num'] != nil
        
        doc_num = params['doc_num']
        
      elsif session[:doc_num] != nil
        
        doc_num = session[:doc_num]
        
      else
        doc_num = nil
      end
        
        
      if doc_num == nil
          number = 3
      elsif doc_num != nil
          if BASICS.is_numeric?(doc_num)
              number = doc_num.to_i
          elsif
              flash['message'] = "Input is not an integer"
              number = 3
          end
        
      end
      
      # write_log("number=" + number.to_s, __FILE__, __LINE__)
      # write_log("number=" + number.to_s, 
      write_log("\nnumber=" + number.to_s, 
                __FILE__.split("/")[-1],
                __LINE__.to_s)

      return number

  end#def get_num_of_docs()

  def get_genre()

      if params['genre']
        
        p_genre = params['genre']
        
      else
        
        p_genre = session[:genre]
        
      end
      
      if p_genre != nil
        
        write_log(p_genre, __FILE__, __LINE__)
        
        return p_genre
        
      else
        
        write_log("soci", __FILE__, __LINE__)
        
        return "soci"
        
      end

  end#def get_genre()
  
  def categorize(a_tags)
      #==========================
      # Steps
      # 1. 
      
      #==========================
      len = a_tags.size
      
      if @category_names != nil
        divisions = @category_names.size
      else
        divisions = 2
      end
      
      num_of_items_in_one_slot = len / divisions
      
      # int n = 0
      
      ret = []
      
      divisions.times do |i|
        
        # ret.append(a_tags[i * (len / divisions)..(i + len / divisions)])
        ret.append(a_tags[i * (num_of_items_in_one_slot)..(i * (num_of_items_in_one_slot) + num_of_items_in_one_slot)])
        
      end      
      
      # return [a_tags[0..(len/2)], a_tags[(len/2)..len]]
      # return [a_tags[0..(len/divisions)], a_tags[(len/divisions)..len]]
      return ret
      
    
  end#def categorize(a_tags)

  def categorize_new(a_tags)
      #==========================
      # Steps
      # 1. 
      
      #==========================
      len = a_tags.size
      
      if @category_names != nil
        divisions = @category_names.size
      else
        divisions = 2
      end

      ret = []
      
      cat = []
      cat[0] = []
      cat[1] = []
      
      a_tags.each do |item|
        
        is_in = false
        
        @kw[0].each do |word|
          
          if item.content.include?(word)
            
            cat[0].push(item)
            
            is_in = true
            
            break
            
          end
          
        end#@kw[0][0].each do |word|

        if is_in == false
          
          cat[1].push(item)
          
        end
        
      end#a_tags.each do |item|
      
      cat.each do |x|
        
        ret.push(x)
        
      end#cat.each do |x|
      
      return ret
    
  end#def categorize_new(a_tags)

  def categorize_new3(a_tags)
      #==========================
      # Steps
      # 1. 
      
      #==========================
      len = a_tags.size
      
      if @category_names != nil
        
          #debug
          write_log(
                "@category_names != nil",
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)


        
        divisions = @category_names.size
        
      else
        
          #debug
          write_log(
                "@category_names => nil",
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)

                
          divisions = 2
      end

      ret = []
      
      cat = []
      
      # num_of_categories = 2
      num_of_categories = @category_names.size
      
      num_of_categories.times do |i|
        
        cat[i] = []
        
      end
      
      #debug
      write_log(
            "cat.size => " + cat.size.to_s,
            # __FILE__,
            __FILE__.split("/")[-1],
            __LINE__.to_s)      

      #debug
      msg = "cat="
      
      for i in (0..(cat.size - 1))
        msg += cat[i].class.to_s + "/"
      end
      
      write_log(
            msg,
            # __FILE__,
            __FILE__.split("/")[-1],
            __LINE__.to_s)      

      
      
      # cat[0] = []
      # cat[1] = []
      
      a_tags.each do |item|
        
        is_in = false
        
        @kw.length.times do |i|
        
          @kw[i].each do |word|
            
            write_log(
                "word=" + word,
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)      
            
            if item.content.include?(word)
              
              item.content = item.content.gsub(word, "<span style='color: green'>#{word}</span>")
              
              cat[i].push(item)
              
              is_in = true
              
              break
              
            end
            
          end#@kw[0].each do |word|
          
          if is_in == true
            break
          end

        end#@kw.length.times do |i|

        if is_in == false
          
          cat[cat.length - 1].push(item)
          
        end

        # if is_in == false
#           
          # cat[1].push(item)
#           
        # end
        
      end#a_tags.each do |item|
      
      cat.each do |x|
        
        ret.push(x)
        
      end#cat.each do |x|
      
      return ret
    
  end#def categorize_new3(a_tags)

  def categorize_new3_int(a_tags)
      #-------------------------------
      # => Setup
      #
      #
      #-------------------------------
      # category = Category.find_by_name("US")
      genre = Genre.find_by_name("Overseas")
      
      # category = Category.find(:all, :conditions => [
      category = Category.find(:first, :conditions => [
                              "name LIKE ? AND genre_id = ?",
                              # "name LIKE ? AND genre_id == ?",
                              # "name LIKE ? AND genre_id LIKE ?",
                              "US", "#{genre.id}"])
      
      #debug
      if category
        
          write_log(
                    "category.id.to_s=" + category.id.to_s,  
                    # __FILE__,
                    __FILE__.split("/")[-1],
                    __LINE__.to_s)


      else
        
          write_log(
                "category => nil",
                # __FILE__,
                __FILE__.split("/")[-1],
                __LINE__.to_s)

      end
      
      # keywords = Keyword.where("category_id LIKE '#{category.id}'")
      # keywords = Keyword.find(:all, :conditions => ["category_id = #{category.id}"])
      keywords = Keyword.find(
                      :all,
                      :conditions => [
                              #HINT '=': http://www.network-theory.co.uk/docs/postgresql/vol1/TheWHEREClause.html "FROM a, b WHERE a.id = b.id AND b.val > 5"
                              "category_id = ?", "#{category.id}"])
                              # "category_id == ?", "#{category.id}"])
                              # "category_id LIKE ?", "#{category.id}"])
      
      objects = [[], []]
      
      # #debug
      # if keywords != nil
#         
          # msg = "keywords.length=" + keywords.length.to_s
#           
      # else
#           
          # msg = "keywords.length => nil"
#           
      # end
#       
      # write_log(
                # msg,
                # # __FILE__,
                # __FILE__.split("/")[-1],
                # __LINE__.to_s)

      #------------------------------
      #
      #
      #
      #------------------------------
      a_tags.each do |atag|
        
          is_in = false # => After 'keywords.each do |kw|', if is_in remains false,
                        # =>  that means that particular a_tag doesn't contain keyword,
                        # =>  meaning that the a_tag goes into 'Others' category
      
          keywords.each do |kw|
              
              # #debug
              # write_log(
                    # "kw=" + kw.name,
                    # # __FILE__,
                    # __FILE__.split("/")[-1], __LINE__.to_s)
              
              if atag.content.include?(kw.name)
              
                  atag.content = atag.content.gsub(
                                            kw.name,
                                            "<span style='color: green'>#{kw.name}</span>")
                  
                  objects[0].push(atag)
                  
                  is_in = true  # => This a_tag has a keyword in it,
                                # =>  so this one goes into 'US' category;
                                # =>  is_in becomes 'true'
                  
                  break # => Break from 'keywords.each do |kw|'; back to 'a_tags.each do |atag|'
                
              end#if atag.content.include?(word)
              
          end#keywords.each do |kw|
          
          if is_in != true
            
              objects[1].push(atag)
            
          end
          
          
      end#a_tags.each do |atag|
      
      return objects
      # return a_tags
  end#def categorize_new3_int(a_tags)

  def categorize_new3_soci(a_tags)
      #==========================
      # Steps
      # 1. 
      
      #==========================
      
      write_log(
            "\n\ncategorize_new3_soci(a_tags)----------------------", 
            # __FILE__,
            __FILE__.split("/")[-1],
            __LINE__.to_s)
      
      len = a_tags.size
      
      # write_log("len: #{len.to_s}",
            # __FILE__.split("/")[-1],
            # __LINE__.to_s)
      
      if @category_names != nil
        divisions = @category_names.size
        
        # write_log("@category_names.size: #{@category_names.size} / divisions: #{divisions}",
            # __FILE__.split("/")[-1],
            # __LINE__.to_s)
        
      else
        divisions = 2
      end

      ret = []
      
      cat = []
      
      # num_of_categories = 2
      num_of_categories = @category_names.size
      
      num_of_categories.times do |i|
        
        cat[i] = []
        
      end
      
      # write_log("cat.size: #{cat.size}",
            # __FILE__.split("/")[-1],
            # __LINE__.to_s)
      
      # cat[0] = []
      # cat[1] = []
      
      # write_log("@kw.length: #{@kw.length}",
            # __FILE__.split("/")[-1],
            # __LINE__.to_s)
      
      a_tags.each do |item|
        
        is_in = false
        
        @kw.length.times do |i|
        
          # write_log("i : #{i}",
                # __FILE__.split("/")[-1],
                # __LINE__.to_s)
        
          @kw[i].each do |word|
            
            # write_log("word: #{word}",
                # __FILE__.split("/")[-1],
                # __LINE__.to_s)
            
            if item.content.include?(word)
              
              # write_log("item.content: #{item.content} / word: #{word}",
                  # __FILE__.split("/")[-1],
                  # __LINE__.to_s)
              
              item.content = item.content.gsub(word, "<span style='color: green'>#{word}</span>")
              
              cat[i].push(item)
              
              is_in = true
              
              break
              
            end
            
          end#@kw[0].each do |word|
          
          if is_in == true
            break
          end

        end#@kw.length.times do |i|

        if is_in == false
          
          # write_log("is_in: #{is_in}",
              # __FILE__.split("/")[-1],
              # __LINE__.to_s)
          
          cat[cat.length - 1].push(item)
          
        end

        # if is_in == false
#           
          # cat[1].push(item)
#           
        # end
        
      end#a_tags.each do |item|
      
      cat.each do |x|
        
        ret.push(x)
        
      end#cat.each do |x|
      
      return ret
    
  end#def categorize_new3(a_tags)
  
  #===============================
  # return => categories
  #
  #
  #===============================
  def try_3(doc_num=3, genre="soci")
    ###########################
    # Steps
    # 1. Get categories
    # 2. Get docs
    # 3. Get a_tags
    # 4. Categorize
    # 9. Return tags     
    ###########################
    
    #=====================
    # 1. Get categories
    #=====================
    # Param

    # Switch
    
    #=====================
    # 2. Get docs
    #=====================
    docs = get_docs(doc_num, genre)

    #=====================
    # 3. Get a_tags
    #=====================
    a_tags = get_atags(docs)

    #----------------------    
    # 4. Categorize
    #----------------------
    # categories = categorize(a_tags)
    # categories = categorize_new(a_tags)
    # categories = categorize_new2(a_tags)
    
    categories = []
    
    if @genre == "int"
        
      categories = categorize_new3_int(a_tags)
      
    elsif @genre == "bus_all"
      
      categories = categorize_new3(a_tags)
      
    elsif @genre == "soci"
      
      categories = categorize_new3_soci(a_tags)
      
    else
      
      categories.push(a_tags)
      
    end
    
    #----------------------
    # 9. Return tags
    #----------------------
    return categories
    # return a_tags
    
  end#def try_3

  #---------  --------------------------------------------
end

