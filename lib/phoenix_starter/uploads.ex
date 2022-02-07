defmodule PhoenixStarter.Uploads do
  @moduledoc """
  Logic for creating direct uploads to AWS S3.
  """

  @default_upload_limit 25 * 1024 * 1024

  @doc """
  Returns a presigned URL to the upload on S3.

  It is assumed that the given param is a list of maps with string keys `variation`
  and `key`. The returned URL is to the map with `variation == "source"`.
  Returns `nil` if no match is found.
  """
  @spec upload_url(list(map())) :: String.t() | nil
  def upload_url(upload) do
    upload
    |> Enum.find(fn u ->
      variation = Map.get(u, "variation")
      variation == "source" && Map.has_key?(u, "key")
    end)
    |> case do
      nil ->
        nil

      source ->
        presigned_url(source["key"])
    end
  end

  defp presigned_url(key) do
    {:ok, url} =
      ExAws.S3.presigned_url(config(), :get, config(:bucket_name), key, virtual_host: true)

    url
  end

  @doc """
  Creates a presigned direct upload.

  Creates the fields necessary for a presigned and authenticated upload request to AWS S3.

  First argument is a `Phoenix.LiveView.UploadEntry` from a LiveView upload form.

  Second argument is options. Currently `opts` accepts:

  - `:acl` - AWS canned ACL for the upload (default: "private")
  - `:prefix` - path prefix for file location in S3 (default: "cache/")
  - `:upload_limit` - limit in bytes for the upload (default: 25mb)

  Returns a map with the fields necessary for successfully completing an upload request.

  ## Examples

      iex> create_upload(%Phoenix.LiveView.UploadEntry{})
       %{method: "post", ...}

  """
  @spec create_upload(Phoenix.LiveView.UploadEntry.t(), keyword(), DateTime.t()) :: {:ok, map()}
  def create_upload(entry, opts \\ [], now \\ Timex.now()) do
    upload_acl = Keyword.get(opts, :acl, "private")
    upload_limit = Keyword.get(opts, :upload_limit, @default_upload_limit)
    upload_prefix = Keyword.get(opts, :prefix, "cache/")

    upload = %{method: "post", url: bucket_url()}
    policy = generate_policy(entry.client_type, upload_acl, upload_limit, upload_prefix, now)

    fields = %{
      :acl => upload_acl,
      "Content-Type" => entry.client_type,
      :key => generate_key(entry, upload_prefix),
      :policy => policy,
      "x-amz-algorithm" => generate_amz_algorithm(),
      "x-amz-credential" => generate_amz_credential(now),
      "x-amz-date" => generate_amz_date(now),
      "x-amz-signature" => generate_signature(policy, now)
    }

    {:ok, Map.put(upload, :fields, fields)}
  end

  defp generate_policy(content_type, acl, upload_limit, prefix, now) do
    expires_at = now |> Timex.shift(minutes: 5) |> Timex.format!("{ISO:Extended:Z}")

    %{
      expiration: expires_at,
      conditions: [
        %{acl: acl},
        %{bucket: config(:bucket_name)},
        ["content-length-range", 0, upload_limit],
        %{"Content-Type" => content_type},
        ["starts-with", "$key", prefix],
        %{"x-amz-algorithm" => generate_amz_algorithm()},
        %{"x-amz-credential" => generate_amz_credential(now)},
        %{"x-amz-date" => generate_amz_date(now)}
      ]
    }
    |> Jason.encode!()
    |> Base.encode64()
  end

  defp generate_signature(policy, now) do
    date = now |> Timex.to_date() |> Timex.format!("{YYYY}{0M}{0D}")

    "AWS4#{config(:secret_access_key)}"
    |> hmac_digest(date)
    |> hmac_digest(config(:region))
    |> hmac_digest("s3")
    |> hmac_digest("aws4_request")
    |> hmac_digest(policy)
    |> hmac_hexdigest()
  end

  defp config() do
    :phoenix_starter
    |> Application.get_env(PhoenixStarter.Uploads)
    |> Enum.into(%{})
    |> Map.merge(ExAws.Config.new(:s3))
  end

  defp config(key), do: Map.get(config(), key)

  defp bucket_url do
    "https://#{config(:bucket_name)}.s3.amazonaws.com"
  end

  defp generate_amz_algorithm, do: "AWS4-HMAC-SHA256"

  defp generate_amz_credential(now) do
    date = now |> Timex.to_date() |> Timex.format!("{YYYY}{0M}{0D}")
    "#{config(:access_key_id)}/#{date}/#{config(:region)}/s3/aws4_request"
  end

  defp generate_amz_date(now) do
    now |> Timex.to_date() |> Timex.format!("{ISO:Basic:Z}")
  end

  defp generate_key(entry, prefix) do
    key = 12 |> :crypto.strong_rand_bytes() |> Base.url_encode64(padding: false)
    ext = Path.extname(entry.client_name)
    Path.join([prefix, "#{key}#{ext}"])
  end

  defp hmac_digest(key, string) do
    :crypto.mac(:hmac, :sha256, key, string)
  end

  defp hmac_hexdigest(digest) do
    Base.encode16(digest, case: :lower)
  end
end
