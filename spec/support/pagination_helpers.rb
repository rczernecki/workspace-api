module PaginationHelpers
  # Method assumes that exactly 3 objects of the resource bundled with the route parameter are present.
  # Please create exactly 3 such objects before calling the method.
  def test_pagination(route)
    # has page[number] and page[size] params
    get route, params: { page: { number: 2, size: 1 } }
    meta = json[:meta]
    aggregate_failures do
      status_ok
      expect(json_data.length).to eq(1)
      expect(meta[:current_page]).to eq(2)
      expect(meta[:per_page]).to eq(1)
    end

    # has no page param
    get route
    meta = json[:meta]
    aggregate_failures do
      status_ok
      expect(json_data.length).to eq(3)
      expect(meta[:current_page]).to eq(1)
      expect(meta[:per_page]).to eq(25)
    end

    # has no page[number] param
    get route, params: { page: { size: 2 } }
    meta = json[:meta]
    aggregate_failures do
      status_ok
      expect(json_data.length).to eq(2)
      expect(meta[:current_page]).to eq(1)
      expect(meta[:per_page]).to eq(2)
    end

    # has no page[size] param
    get route, params: { page: { number: 1 } }
    meta = json[:meta]
    aggregate_failures do
      status_ok
      expect(json_data.length).to eq(3)
      expect(meta[:current_page]).to eq(1)
      expect(meta[:per_page]).to eq(25)
    end

    # contains metadata in response
    get route, params: { page: { number: 2, size: 1 } }
    meta = json[:meta]
    aggregate_failures do
      expect(meta.length).to eq(4)
      expect(meta.keys).to contain_exactly(
                             :total, :total_pages, :current_page, :per_page
                           )
      expect(meta[:total]).to eq(3)
      expect(meta[:total_pages]).to eq(3)
      expect(meta[:current_page]).to eq(2)
      expect(meta[:per_page]).to eq(1)
    end

    # has no prev link
    get '/places', params: { page: { number: 1, size: 2 } }
    links = json[:links]
    aggregate_failures do
      expect(links.length).to eq(3)
      expect(links.keys).to contain_exactly(
                              :first, :last, :next
                            )
      expect(links[:first]).to eq("#{request.base_url + request.path}?page[number]=1&page[size]=2")
      expect(links[:last]).to eq("#{request.base_url + request.path}?page[number]=2&page[size]=2")
      expect(links[:next]).to eq("#{request.base_url + request.path}?page[number]=2&page[size]=2")
    end

    # has no next link
    get '/places', params: { page: { number: 2, size: 1 } }
    links = json[:links]
    aggregate_failures do
      expect(links.length).to eq(4)
      expect(links.keys).to contain_exactly(
                              :first, :last, :prev, :next
                            )
      expect(links[:first]).to eq("#{request.base_url + request.path}?page[number]=1&page[size]=1")
      expect(links[:last]).to eq("#{request.base_url + request.path}?page[number]=3&page[size]=1")
      expect(links[:prev]).to eq("#{request.base_url + request.path}?page[number]=1&page[size]=1")
      expect(links[:next]).to eq("#{request.base_url + request.path}?page[number]=3&page[size]=1")
    end

    # has all links
    get '/places', params: { page: { number: 3, size: 1 } }
    links = json[:links]
    aggregate_failures do
      expect(links.length).to eq(3)
      expect(links.keys).to contain_exactly(
                              :first, :last, :prev
                            )
      expect(links[:first]).to eq("#{request.base_url + request.path}?page[number]=1&page[size]=1")
      expect(links[:last]).to eq("#{request.base_url + request.path}?page[number]=3&page[size]=1")
      expect(links[:prev]).to eq("#{request.base_url + request.path}?page[number]=2&page[size]=1")
    end
  end
end
