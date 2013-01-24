def full_title(page_title)
  if page_title.empty?
    "No Title"
  else
    "#{page_title}"  
  end
end
