Factory.define :page do |page|
  page.sequence :title do |n|
    "Title for page #{n}"
  end

  page.sequence :permalink do |n|
    "test/auto_gen_link_url_#{n}"
  end
end
