FactoryGirl.define do
  factory :page do
    sequence :title do |n|
      "Title for page #{n}"
    end

    sequence :permalink do |n|
      "test/auto_gen_link_url_#{n}"
    end

    published true
  end

  factory :unpublished_page, :parent => :page do
    published false
  end
end
