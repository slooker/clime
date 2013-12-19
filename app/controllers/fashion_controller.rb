class FashionController < ApplicationController
    require "json"
    require 'open-uri'
    require 'pp'

    before_filter :setup

    def test_weather
        weather_data = get_weather_by_zip(89115)
        render :json => weather_data
    end

    def test_glance
        url = "http://glance-api.zapposlabs.net/1/collections?key=#{@glance_key}&per_page=1"
        render :json => fetch_url(url)
        #get_glance_data
    end
    
    def get_collection_by_id
        id = params[:id]
        #url = "http://glance-api.zapposlabs.net/1/collections/#{id}?key=#{@glance_key}"
        #fetch_url(url)
        c = Collection.find(id)
        puts "Id: #{id} Collection #{pp c}"
        render :json => c
    end
    
    def fetch_url(url)
        r = open(url).read
        json_object = JSON.parse(r)
        return json_object
    end

    def get_glance_data
        ## TODO: fetch glance data for a specific outfit  
        ## Hard coded to fetch first collection
        ## Need to be able to search a specific collection
        url = "http://glance-api.zapposlabs.net/1/collections?key=#{@glance_key}&per_page=1"
        fetch_url(url)
    end
    

    
    def setup_collections 
        url = "http://glance-api.zapposlabs.net/1/collections?key=#{@glance_key}&per_page=5"
        json_data = fetch_url(url)
        collections = json_data['response']
        #puts "Collections: #{pp collections}" # Bad idea...
        next_page = nil
        while(next_page)
            collections.each do |c|
                newCollection = Collection.find_or_initialize_by_slug(c['slug'])
            
                #newCollection = Collection.new
                newCollection.slug = c['slug']
                newCollection.content = c['content']
                newCollection.name = c['headline']
                newCollection.id = c['id']
                puts "Collection: #{newCollection.id} - #{newCollection.name}"
           
                c['tags'].each do |tag|
                    t = Tag.find_or_initialize_by_slug(tag['slug'])
                    t.category = tag['category']
                    t.name = tag['name']
                    t.slug = tag['slug']
                    t.id = tag['id']
                    t.save
                   
                    newCollection.tags << t
                end
                newCollection.save

            end
            
            json_data = fetch_url("#{url}&page=#{json_data['pagination']['next']}")
            next_page = json_data['pagination']['next']
            puts "Next page: #{next_page}"
        end
        render :json => "Done loading."
    end
    

    
    def get_weather_by_zip(zip)
        url = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=#{zip}&format=json&num_of_days=5&key=#{@weather_key}"
        json_object = fetch_url(url)
        #parsed_json_object = JSON.parse(json_object)
        return json_object['data']['current_condition'][0]
    end

    private
    def setup
        @glance_key = ""
        @weather_key = ""
    end    
end
