namespace UserManagementService.Core.Entities;

// These entities are shared across services and should be in a shared library
// For now, we'll define them here to match the database schema

public class Country
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty; // ISO country code (e.g., "IN", "US")
    public string Name { get; set; } = string.Empty;
    public string Region { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;

    public ICollection<City> Cities { get; set; } = new List<City>();
    public ICollection<User> Users { get; set; } = new List<User>();
}

public class City
{
    public Guid Id { get; set; }
    public Guid CountryId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    public bool IsActive { get; set; } = true;

    public Country Country { get; set; } = null!;
    public ICollection<User> Users { get; set; } = new List<User>();
}

public class Language
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty; // en, hi, te, etc.

    public ICollection<UserPreference> UserPreferences { get; set; } = new List<UserPreference>();
}

public class Currency
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty; // USD, EUR, INR, etc.
    public string Name { get; set; } = string.Empty;
    public string Symbol { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;

    public ICollection<UserPreference> UserPreferences { get; set; } = new List<UserPreference>();
}

public class DocumentType
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty; // passport, visa, medical_records, insurance_card
    public string Description { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;

    public ICollection<UserDocument> UserDocuments { get; set; } = new List<UserDocument>();
}
