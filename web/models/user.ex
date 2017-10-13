defmodule Api.User do
  use Api.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @foreign_key_type :binary_id

  schema "user" do
    field :lat, :float
    field :lng, :float
    field :suspended, :boolean, default: false
    field :suspended_until, Ecto.DateTime, default: nil
    field :expelled, :boolean, default: false
    field :takarma, :integer, default: 100
    belongs_to :phone, Api.Phone
    has_one :auth_tokens, Api.AuthToken
    has_many :posts, Api.Post
    has_many :votes, Api.Vote
    has_many :flags, Api.Vote

    timestamps()
  end

  def register_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:lat, :lng])
    |> validate_required([:lat, :lng])
    |> put_assoc(:phone, params.phone)
  end

  def update_location_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:lat, :lng])
    |> validate_required([:lat, :lng])
  end

  def suspend_user_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> put_change(:suspended, true)
    |> put_change(:suspended_until, one_day_from_now)
  end

  def unsuspend_user_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> put_change(:suspended, false)
    |> put_change(:suspended_until, nil)
  end

  def expel_user_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> put_change(:expelled, true)
  end

  def incr_takarma_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_change(:takarma, struct.takarma + 1)
  end

  def decr_takarma_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_change(:takarma, struct.takarma - 1)
  end

  def double_decr_takarma_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_change(:takarma, struct.takarma - 2)
  end

  def double_incr_takarma_changeset(struct, params \\ %{}) do
    struct 
    |> cast(params, [])
    |> put_change(:takarma, struct.takarma + 2)
  end

  defp one_day_from_now do
    {{a,b,c},{hh,mm,ss}} = :calendar.universal_time()
    {x,y,z} = :calendar.gregorian_days_to_date(:calendar.date_to_gregorian_days({a,b,c}) + 1)
    time = Ecto.DateTime.from_erl({{x,y,z},{hh,mm,ss}})
  end

  def is_suspended?(user) do
    user.suspended && user.suspended_until != nil
      && Ecto.DateTime.compare(user.suspended_until, Ecto.DateTime.utc) == :gt
  end

  def is_expelled?(user) do
    user.expelled
  end

end
