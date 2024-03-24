shared_examples "fields returnable" do
  it "all public" do
    %w[id email admin created_at updated_at].each do |attr|
      expect(response_item[attr]).to eq user_item.send(attr).as_json
    end
  end

  it "not private" do
    %w[password encrypted_password].each do |attr|
      expect(response_item).not_to have_key(attr)
    end
  end
end
