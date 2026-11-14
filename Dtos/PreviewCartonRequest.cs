namespace ExpiryTracker.Api.Dtos;

// What Flutter sends right after the camera reads a QR, before the supervisor confirms.
public record PreviewCartonRequest(string QrText);
