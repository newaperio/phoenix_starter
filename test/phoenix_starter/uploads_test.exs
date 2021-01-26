defmodule PhoenixStarter.UploadsTest do
  use ExUnit.Case

  alias PhoenixStarter.Uploads

  describe "upload_url/1" do
    test "returns a signed URL if source variation present" do
      upload = [
        %{"variation" => "thumbnail"},
        %{"variation" => "source", "key" => "foo/test.jpeg"}
      ]

      %{host: host, path: path, port: port, query: query} =
        upload |> Uploads.upload_url() |> URI.parse()

      assert host == "test-phoenix-starter-uploads.s3.amazonaws.com"
      assert path == "/foo/test.jpeg"
      assert port == 443
      refute is_nil(query)
    end

    test "returns nil if source variation not present" do
      upload = [
        %{"variation" => "thumbnail"}
      ]

      assert is_nil(Uploads.upload_url(upload))
    end
  end

  test "create_upload/3 returns a signed upload" do
    {:ok, now} = Timex.parse("2019-03-06", "{YYYY}-{0M}-{D}")

    entry = %Phoenix.LiveView.UploadEntry{
      client_name: "skywalker.jpeg",
      client_type: "image/jpeg"
    }

    {:ok, upload} = Uploads.create_upload(entry, [acl: "private", prefix: "foo/"], now)

    assert upload.method == "post"
    assert upload.url == "https://test-phoenix-starter-uploads.s3.amazonaws.com"
    assert is_map(upload.fields), "is not a map"
    assert upload.fields[:acl] == "private"
    assert upload.fields["Content-Type"] == "image/jpeg"
    assert upload.fields[:key] =~ ~r/foo\/[A-z0-9-_]+.jpeg/
    assert upload.fields[:policy] == policy_fixture()
    assert upload.fields["x-amz-algorithm"] == "AWS4-HMAC-SHA256"

    assert upload.fields["x-amz-credential"] ==
             "AKIATEST/20190306/us-east-1/s3/aws4_request"

    assert upload.fields["x-amz-date"] == "20190306T000000Z"

    assert upload.fields["x-amz-signature"] ==
             "fbb059a13abf4af58b1e479c5312ae7ceca6c43d138acf8ef68259aafe8b1ed8"
  end

  defp policy_fixture() do
    "eyJjb25kaXRpb25zIjpbeyJhY2wiOiJwcml2YXRlIn0seyJidWNrZXQiOiJ0ZXN0LXBob2VuaXgtc3RhcnRlci11cGxvYWRzIn0sWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsMCwyNjIxNDQwMF0seyJDb250ZW50LVR5cGUiOiJpbWFnZS9qcGVnIn0sWyJzdGFydHMtd2l0aCIsIiRrZXkiLCJmb28vIl0seyJ4LWFtei1hbGdvcml0aG0iOiJBV1M0LUhNQUMtU0hBMjU2In0seyJ4LWFtei1jcmVkZW50aWFsIjoiQUtJQVRFU1QvMjAxOTAzMDYvdXMtZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJ9LHsieC1hbXotZGF0ZSI6IjIwMTkwMzA2VDAwMDAwMFoifV0sImV4cGlyYXRpb24iOiIyMDE5LTAzLTA2VDAwOjA1OjAwWiJ9"
  end
end
