namespace MinimalApi.Common;

public class Result
{
    public bool IsSuccess { get; }
    public string? ErrorMessage { get; }
    public int StatusCode { get; }

    protected Result(bool isSuccess, string? errorMessage, int statusCode = 200)
    {
        IsSuccess = isSuccess;
        ErrorMessage = errorMessage;
        StatusCode = statusCode;
    }

    public static Result Success() => new(true, null, 200);
    public static Result Failure(string errorMessage, int statusCode = 400) => new(false, errorMessage, statusCode);
}

public class Result<T> : Result
{
    public T? Value { get; }

    private Result(bool isSuccess, T? value, string? errorMessage, int statusCode = 200)
        : base(isSuccess, errorMessage, statusCode)
    {
        Value = value;
    }

    public static Result<T> Success(T value) => new(true, value, null, 200);
    public static new Result<T> Failure(string errorMessage, int statusCode = 400) => new(false, default, errorMessage, statusCode);
}
