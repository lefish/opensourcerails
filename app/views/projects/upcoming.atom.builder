atom_feed do |feed|
  feed.title "Upcoming Open Source Rails Projects"
  @upcoming.each do |upcoming|
    feed.entry(upcoming, :published => upcoming.promoted_at, :updated => upcoming.promoted_at) do |entry|
      entry.title(upcoming.title)
      entry.content(image_tag(AppConfig.site_url+upcoming.preview_url, :style => "float:left;margin-right:10px")+simple_format(upcoming.description)+"<br style='clear:both' />", :type => 'html')

      entry.author do |author|
        author.name(upcoming.owner.to_s)
      end
    end
  end
end