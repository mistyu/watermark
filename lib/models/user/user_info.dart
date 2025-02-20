class UserInfo {
  final int? id;
  final String? deviceId;
  final String? nickname;
  final String? avatar;
  final String? phone;
  final int? userType; // 0: 游客 1: 正式用户
  final int? isMember;
  final DateTime? memberExpireTime;

  UserInfo({
    this.id,
    this.deviceId,
    this.nickname,
    this.avatar,
    this.phone,
    this.userType,
    this.isMember,
    this.memberExpireTime,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    try {
      return UserInfo(
        id: json['id'] is String ? int.parse(json['id']) : json['id'],
        deviceId: json['deviceId']?.toString(),
        nickname: json['nickname']?.toString(),
        avatar: json['avatar']?.toString(),
        phone: json['phone']?.toString(),
        userType: json['userType'] is String
            ? int.parse(json['userType'])
            : json['userType'],
        isMember: json['isMember'] is String
            ? int.parse(json['isMember'])
            : json['isMember'],
        memberExpireTime: json['memberExpireTime'] != null
            ? DateTime.parse(json['memberExpireTime'])
            : null,
      );
    } catch (e) {
      print('Error parsing UserInfo: $e');
      print('Raw JSON: $json');
      rethrow;
    }
  }

  bool get isVip => isMember == 0;

  @override
  String toString() {
    return 'UserInfo{id: $id, deviceId: $deviceId, nickname: $nickname, '
        'avatar: $avatar, phone: $phone, userType: $userType, '
        'isMember: $isMember, memberExpireTime: $memberExpireTime}';
  }
}
