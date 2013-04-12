module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_id = "#{column}_header"
    #if column == "title"
    #  css_id = "title_header"
    #elsif column == "release_date"
    #  css_id = "release_date_header"
    #end
    direction = (column == orderby_column && orderby_direction == "asc") ? "desc" : "asc"
    link_to title, movies_path({ :orderby => column, :direction => direction, :ratings => @selected_ratings }), { :id => css_id }
  end

end
