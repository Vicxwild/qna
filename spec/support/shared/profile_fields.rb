shared_examples "fields returnable" do
  it "all public" do
    expect(response_item).to include(
      "id" => user_item.id,
      "email" => user_item.email,
      "admin" => user_item.admin,
      "created_at" => user_item.created_at.as_json,
      "updated_at" => user_item.updated_at.as_json
    )
  end

  it "not private" do
    %w[password encrypted_password].each do |attr|
      expect(response_item).not_to have_key(attr)
    end
  end
end
