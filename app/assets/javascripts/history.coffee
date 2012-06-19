window.load_history = (book_id, history_list) ->
  url = "/book/" + book_id + "/events.json"
  $.getJSON(url)
  .done (data) ->
    for event in data.reverse()
      do ->
        occured_on = new Date(event.occured_on).toLocaleString()
        console.log occured_on
        history_list.append $("<li>").text occured_on + " : " + event.class_name


