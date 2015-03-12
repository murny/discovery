class SymphonyService

  def initialize
    @ws_endpoint = "https://ws.library.ualberta.ca/symws3/rest/standard/"
    @method = "lookupTitleInfo"
    @parameters = "?clientID=Primo&marcEntryFilter=ALL&includeItemInfo=true&titleID="
  end

  def get_status(id, item_id, library)
    url = @ws_endpoint+@method+@parameters+id+"&libraryFilter="+library
    document = Nokogiri::XML(open(url).read)
    nodes = document.xpath("//xmlns:ItemInfo", :xmlns=>"http://schemas.sirsidynix.com/symws/standard")
    nodes.each do |node|
      if node.at_xpath("//xmlns:itemID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text == item_id
        return node.at_xpath("//xmlns:currentLocationID", :xmlns=>"http://schemas.sirsidynix.com/symws/standard").text
      end
    end
  end
end
