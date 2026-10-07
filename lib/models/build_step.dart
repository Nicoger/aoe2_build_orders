enum StepType { villager, research, ageUp }

class RedistributionItem {
  final int count;
  final String resource;
  final String note;

  RedistributionItem({
    required this.count,
    required this.resource,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'count': count,
        'resource': resource,
        'note': note,
      };

  factory RedistributionItem.fromJson(Map<String, dynamic> json) =>
      RedistributionItem(
        count: json['count'],
        resource: json['resource'],
        note: json['note'],
      );
}

class BuildStep {
  final StepType type;
  final String? villagerRange;
  final String mainAction;
  final String? nextActionHint;
  final double durationInGameSecs;
  final List<RedistributionItem>? ageRedistribution;

  BuildStep({
    required this.type,
    this.villagerRange,
    required this.mainAction,
    this.nextActionHint,
    required this.durationInGameSecs,
    this.ageRedistribution,
  });

  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'villagerRange': villagerRange,
        'mainAction': mainAction,
        'nextActionHint': nextActionHint,
        'durationInGameSecs': durationInGameSecs,
        'ageRedistribution': ageRedistribution?.map((e) => e.toJson()).toList(),
      };

  factory BuildStep.fromJson(Map<String, dynamic> json) => BuildStep(
        type: StepType.values.firstWhere((e) => e.toString() == json['type'],
            orElse: () => StepType.villager),
        villagerRange: json['villagerRange'],
        mainAction: json['mainAction'],
        nextActionHint: json['nextActionHint'],
        durationInGameSecs: (json['durationInGameSecs'] as num).toDouble(),
        ageRedistribution: json['ageRedistribution'] != null
            ? (json['ageRedistribution'] as List)
                .map((e) =>
                    RedistributionItem.fromJson(Map<String, dynamic>.from(e)))
                .toList()
            : null,
      );
}
