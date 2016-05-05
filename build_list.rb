require "open-uri"
require "json"

def raw_icon_url(path:)
  "https://cdn.rawgit.com/mapbox/maki/master/#{path}"
end

url = "https://api.github.com/repos/mapbox/maki/contents/icons"
response = JSON.parse(open(url).read)

icons = response.
  map do |item|
    {
      name: File.basename(item["name"], File.extname(item["name"])),
      path: item["path"],
    }
  end.select do |icon|
    icon[:path].match(/.*15\.svg$/)
  end.sort_by do |icon|
    icon[:name]
  end

list = icons.map do |icon|
  {
    name: icon[:name].match(/([a-z\-]+)+\-[0-9]+/)[1],
    url: raw_icon_url(path: icon[:path]),
  }
end

puts "Icon | Preview"
puts "-----|--------"
list.each do |icon|
  puts "| #{icon[:name]} | ![#{icon[:name]}](#{icon[:url]}) |"
end
