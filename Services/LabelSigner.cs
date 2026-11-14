using System.Security.Cryptography;
using System.Text;
using ExpiryTracker.Api.Dtos;

namespace ExpiryTracker.Api.Services;

// Signs carton labels so the store app accepts only QRs that our system printed.
//
// HMAC = a short code made from (label data + a secret key). Only the server knows the key,
// so nobody can make a valid code for a fake or edited label. Changing one letter of the QR
// gives a completely different code, and the scan is rejected.
// Dart equivalent: Hmac(sha256, key).convert(utf8.encode(text)) from package:crypto.
//
// Singleton: it has no database and no per-request state, so one instance serves everyone.
public class LabelSigner
{
    // 16 of the 32 HMAC bytes are plenty to block forgery, and keep the QR small.
    private const int SignatureBytes = 16;

    private readonly byte[] _key;

    public LabelSigner(IConfiguration config)
    {
        // Like dotenv.env['...'] in Flutter. Fail at startup, not on the first scan.
        var key = config["Labels:SigningKey"];
        if (string.IsNullOrWhiteSpace(key) || key.Length < 32)
            throw new InvalidOperationException("Labels:SigningKey is missing or shorter than 32 characters.");

        _key = Encoding.UTF8.GetBytes(key);
    }

    public string Sign(CartonQr qr)
    {
        var hash = HMACSHA256.HashData(_key, Encoding.UTF8.GetBytes(qr.SignedText()));
        // Base64Url: like base64, but with no '+', '/' or '=' (safe inside JSON and URLs).
        return Base64Url(hash.AsSpan(0, SignatureBytes));
    }

    public bool IsValid(CartonQr qr)
    {
        var expected = Encoding.ASCII.GetBytes(Sign(qr));
        var actual = Encoding.ASCII.GetBytes(qr.Signature ?? "");
        // Compares in constant time, so an attacker can't guess the code one character at a time
        // by measuring how fast we answer.
        return CryptographicOperations.FixedTimeEquals(expected, actual);
    }

    private static string Base64Url(ReadOnlySpan<byte> bytes) =>
        Convert.ToBase64String(bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_');
}
