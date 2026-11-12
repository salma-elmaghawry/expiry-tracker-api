import 'package:flutter/material.dart';

@immutable
class StatusTone {
  final Color background;
  final Color foreground;
  final Color accent;

  const StatusTone({
    required this.background,
    required this.foreground,
    Color? accent,
  }) : accent = accent ?? foreground;

  static StatusTone lerp(StatusTone a, StatusTone b, double t) {
    return StatusTone(
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
    );
  }
}

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  final StatusTone expired;
  final StatusTone within3Days;
  final StatusTone within4To7Days;
  final StatusTone later;
  final StatusTone active;
  final StatusTone discounted;
  final StatusTone sold;
  final StatusTone wasted;

  const StatusColors({
    required this.expired,
    required this.within3Days,
    required this.within4To7Days,
    required this.later,
    required this.active,
    required this.discounted,
    required this.sold,
    required this.wasted,
  });

  static const StatusColors light = StatusColors(
    expired: StatusTone(
      background: Color(0xFFFFE4E0),
      foreground: Color(0xFFA3140F),
      accent: Color(0xFFBA1A1A),
    ),
    within3Days: StatusTone(
      background: Color(0xFFFFE9D1),
      foreground: Color(0xFF8A3D00),
      accent: Color(0xFFE36A00),
    ),
    within4To7Days: StatusTone(
      background: Color(0xFFFFF5D1),
      foreground: Color(0xFF5E4A00),
      accent: Color(0xFFA07800),
    ),
    later: StatusTone(
      background: Color(0xFFF0F3F1),
      foreground: Color(0xFF5B6661),
    ),
    active: StatusTone(
      background: Color(0xFFE2EEFA),
      foreground: Color(0xFF0B4F8A),
    ),
    discounted: StatusTone(
      background: Color(0xFFEFE7FA),
      foreground: Color(0xFF5E3596),
    ),
    sold: StatusTone(
      background: Color(0xFFE2F1E4),
      foreground: Color(0xFF1E5E2C),
    ),
    wasted: StatusTone(
      background: Color(0xFFFBE3E1),
      foreground: Color(0xFF93000A),
      accent: Color(0xFFBA1A1A),
    ),
  );

  static const StatusColors dark = StatusColors(
    expired: StatusTone(
      background: Color(0xFF3D1512),
      foreground: Color(0xFFFFB4AB),
      accent: Color(0xFFFF897D),
    ),
    within3Days: StatusTone(
      background: Color(0xFF3A2208),
      foreground: Color(0xFFFFC58A),
      accent: Color(0xFFFF9F43),
    ),
    within4To7Days: StatusTone(
      background: Color(0xFF322A0A),
      foreground: Color(0xFFF2D675),
      accent: Color(0xFFE5C14B),
    ),
    later: StatusTone(
      background: Color(0xFF1E2522),
      foreground: Color(0xFF9DA8A3),
    ),
    active: StatusTone(
      background: Color(0xFF0F2A44),
      foreground: Color(0xFF9CCBFF),
    ),
    discounted: StatusTone(
      background: Color(0xFF2C1F44),
      foreground: Color(0xFFD4BBFF),
    ),
    sold: StatusTone(
      background: Color(0xFF133019),
      foreground: Color(0xFF9BD8A4),
    ),
    wasted: StatusTone(
      background: Color(0xFF3D1512),
      foreground: Color(0xFFFFB4AB),
      accent: Color(0xFFFF897D),
    ),
  );

  @override
  StatusColors copyWith({
    StatusTone? expired,
    StatusTone? within3Days,
    StatusTone? within4To7Days,
    StatusTone? later,
    StatusTone? active,
    StatusTone? discounted,
    StatusTone? sold,
    StatusTone? wasted,
  }) {
    return StatusColors(
      expired: expired ?? this.expired,
      within3Days: within3Days ?? this.within3Days,
      within4To7Days: within4To7Days ?? this.within4To7Days,
      later: later ?? this.later,
      active: active ?? this.active,
      discounted: discounted ?? this.discounted,
      sold: sold ?? this.sold,
      wasted: wasted ?? this.wasted,
    );
  }

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;

    return StatusColors(
      expired: StatusTone.lerp(expired, other.expired, t),
      within3Days: StatusTone.lerp(within3Days, other.within3Days, t),
      within4To7Days: StatusTone.lerp(within4To7Days, other.within4To7Days, t),
      later: StatusTone.lerp(later, other.later, t),
      active: StatusTone.lerp(active, other.active, t),
      discounted: StatusTone.lerp(discounted, other.discounted, t),
      sold: StatusTone.lerp(sold, other.sold, t),
      wasted: StatusTone.lerp(wasted, other.wasted, t),
    );
  }
}

extension StatusColorsContext on BuildContext {
  StatusColors get statusColors => Theme.of(this).extension<StatusColors>()!;
}
