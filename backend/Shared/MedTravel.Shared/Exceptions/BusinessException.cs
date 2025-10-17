namespace MedTravel.Shared.Exceptions;

public class BusinessException : Exception
{
    public int StatusCode { get; set; }
    public List<string> Errors { get; set; } = new();

    public BusinessException(string message, int statusCode = 400) : base(message)
    {
        StatusCode = statusCode;
    }

    public BusinessException(string message, List<string> errors, int statusCode = 400) : base(message)
    {
        StatusCode = statusCode;
        Errors = errors;
    }
}

public class NotFoundException : BusinessException
{
    public NotFoundException(string message) : base(message, 404) { }
}

public class UnauthorizedException : BusinessException
{
    public UnauthorizedException(string message) : base(message, 401) { }
}

public class ForbiddenException : BusinessException
{
    public ForbiddenException(string message) : base(message, 403) { }
}

public class ValidationException : BusinessException
{
    public ValidationException(string message, List<string> errors) : base(message, errors, 422) { }
}
