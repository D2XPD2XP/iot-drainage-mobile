class Image {
  String? url;
  num? lastUpdated;

  Image({
    this.url,
    this.lastUpdated,
  });

  Image.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    lastUpdated = json['last_updated'] as num?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['last_updated'] = lastUpdated;
    return data;
  }
}
