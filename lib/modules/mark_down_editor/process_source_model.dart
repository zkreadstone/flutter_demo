import 'dart:convert';

enum SourceType { user, role, channel }

ProcessSourceModel processSourceModelFromJson(String str) =>
    ProcessSourceModel.fromJson(json.decode(str));

String processSourceModelToJson(ProcessSourceModel data) =>
    json.encode(data.toJson());

class ProcessSourceModel {
  ProcessSourceModel({
    this.users,
    this.roles,
    this.channels,
  });

  List<Channel> users;
  List<Channel> roles;
  List<Channel> channels;

  factory ProcessSourceModel.fromJson(Map<String, dynamic> json) =>
      ProcessSourceModel(
        users: List<Channel>.from(json["users"].map((x) {
          return Channel.fromJson(x, SourceType.user);
        })),
        roles: List<Channel>.from(json["roles"].map((x) {
          return Channel.fromJson(x, SourceType.role);
        })),
        channels: List<Channel>.from(json["channels"].map((x) {
          return Channel.fromJson(x, SourceType.channel);
        })),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "channels": List<dynamic>.from(channels.map((x) => x.toJson())),
      };
}

class Channel {
  Channel({
    this.avatar,
    this.name,
    this.id,
    this.sourceType,
  });
  String avatar;
  String name;
  int id;
  SourceType sourceType;

  factory Channel.fromJson(Map<String, dynamic> json, SourceType type) =>
      Channel(
        avatar: json["avatar"],
        name: json["name"],
        id: json["id"],
        sourceType: type,
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "name": name,
        "id": id,
        "sourceType": sourceType,
      };
}
