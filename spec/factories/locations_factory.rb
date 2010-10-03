Factory.define :location do |location|
  location.name 'test'
end

Factory.define :location_with_page, :parent => :location do |location|
  location.association :page
end

Factory.define :location_without_page, :parent => :location do |location|
  location.page nil
  location.path 'test'
end

Factory.define :location_with_single_child, :parent => :location do |location|
  location.after_create do |me|
    child = Factory(:location)
    child.move_to_child_of(me)
  end
end

Factory.define :location_with_children_2_deep, :parent => :location do |location|
  location.after_create do |me|
    child = Factory(:location)
    child.move_to_child_of(me)
    child.reload
    sub_child = Factory(:location)
    sub_child.move_to_child_of(child)
  end
end

Factory.define :location_with_2_children_each_with_2_children, 
               :parent => :location do |location|
  location.after_create do |me|
    2.times do 
      child = Factory(:location)
      child.move_to_child_of(me)
      2.times do 
        child.reload
        sub_child = Factory(:location)
        sub_child.move_to_child_of(child)
      end
    end
  end
end
