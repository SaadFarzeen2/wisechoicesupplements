class ChatGPTConfig {
  final String? botName;
  final dynamic botAvatar;
  final String? model;
  final int? maxToken;
  final double? temperature;
  final double? topP;
  final int? n;
  final bool? stream;
  final int? logprobs;
  final bool? echo;
  final List<String>? stop;
  final double? presencePenalty;
  final double? frequencyPenalty;
  final int? bestOf;

  ChatGPTConfig({
    this.botName,
    this.botAvatar,
    this.model,
    this.maxToken,
    this.temperature,
    this.topP,
    this.n,
    this.stream,
    this.logprobs,
    this.echo,
    this.stop,
    this.presencePenalty,
    this.frequencyPenalty,
    this.bestOf,
  });


  factory ChatGPTConfig.fromJson(Map<String, dynamic> json){
    return ChatGPTConfig(
      botName: json['nameInformation'],
      botAvatar: json['avatarInformation'],
      model:json['modelSetting'],
      maxToken: _jsonToInt(json['maxTokensSetting']),
      temperature:_jsonToDouble(json['temperatureSetting']),
      topP:_jsonToDouble(json['topPSetting']),
      n:_jsonToInt(json['nSetting']),
      stream:json['streamSetting'],
      logprobs:_jsonToInt(json['logprobsSetting']),
      echo:json['echoSetting'],
      stop:_stringToList(json['stopSetting']),
      presencePenalty:_jsonToDouble(json['presencePenaltySetting']),
      frequencyPenalty:_jsonToDouble(json['frequencyPenaltySetting']),
      bestOf:_jsonToInt(json['bestOfSetting']),
    );
  }

  static int? _jsonToInt(dynamic data){
    if(data != null){
      if(data is int || data is String){
        return int.tryParse(data.toString());
      }
    }
    return null;
  }
  static double? _jsonToDouble(dynamic data){
    if(data != null){
      if(data is num || data is String){
        return double.tryParse(data.toString());
      }
    }
    return null;
  }
  static List<String>? _stringToList(dynamic data){
    if(data != null){
      if(data is String && data.isNotEmpty){
        List<String> result = [];
        result = data.split(',');
        return result.map((e) => e.trim()).toList();
      }
    }
    return null;
  }
}
