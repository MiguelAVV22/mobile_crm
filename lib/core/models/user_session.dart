class UserSession {
  final String token;
  final String email;
  final String rol;
  final String? tenantId;
  final String? nombreTenant;
  final String nombreCompleto;
  final String? avatarUrl;
  final List<String> permisos;

  UserSession({
    required this.token,
    required this.email,
    required this.rol,
    this.tenantId,
    this.nombreTenant,
    required this.nombreCompleto,
    this.avatarUrl,
    this.permisos = const [],
  });

  bool get isCliente => rol == 'ROLE_CLIENTE';
  bool get isAdminEmpresa => rol == 'ROLE_ADMIN_EMPRESA';
  bool get isSuperAdmin => rol == 'ROLE_SUPER_ADMIN';

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      token: json['token'] as String? ?? '',
      email: json['email'] as String? ?? '',
      rol: json['rol'] as String? ?? '',
      tenantId: json['tenantId'] as String?,
      nombreTenant: json['nombreTenant'] as String?,
      nombreCompleto: json['nombreCompleto'] as String? ?? 'Usuario',
      avatarUrl: json['avatarUrl'] as String?,
      permisos: (json['permisos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'rol': rol,
      'tenantId': tenantId,
      'nombreTenant': nombreTenant,
      'nombreCompleto': nombreCompleto,
      'avatarUrl': avatarUrl,
      'permisos': permisos,
    };
  }
}

