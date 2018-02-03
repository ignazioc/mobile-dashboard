SCHEDULER.every '1h', :first_in => 0 do |job|

  url = "https://www.apple.com/de/itunes/charts/free-apps/"
  page = Nokogiri::HTML(RestClient.get(url))   
  list =  page.css('div.section-content li')
  rows = list.each_with_index.map { | item , counter|
    image_url =  "https://www.apple.com/" + item.css("a img").first["src"]
    app_title =  item.css('h3 a').text

    { cols: [{ value: "#{(counter + 1).to_s}" }, { value: "<img src=\"#{image_url}\" height=\"80%\">" }, { class: 'left', value: "#{app_title}"} ]}
  }

  
  first_10 = rows.shift(20)
  second_10 = rows.shift(10)

  # rows = reviews.map { | hash | { cols: [ { value: "<img src=\"https://www.apple.com//autopush/de/itunes/charts/free-apps/images/2018/2/ff5203fbdc028e799ba7c06e48c76b229a5e3861c80b4ab1e849917700cd4415.jpg\">" }, { class: 'left', value: "Facebook"} ]} }

  send_event('top20_1', { rows: first_10 } )
  send_event('top20_2', { rows: second_10 } )
end
