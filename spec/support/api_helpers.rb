module ApiHelpers
  def json_response_body
    @json ||= JSON.parse(response.body)
  end
end
