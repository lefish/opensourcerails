atom_feed do |feed|
  feed.title "Activities of Project #{@project.title}"
  
  @activities.each do |activity|
    feed.entry(activity_display(activity)) do |entry|
      entry.title(activity.target_name)
      entry.content(activity_display(activity), :type => 'html')
      entry.author do |author|
        author.name(activity.user_name.to_s)
      end      
    end
  end
end