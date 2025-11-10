class TalentModel {
  int? count;
  List<DataMost>? data;
  String? image;
  String? key;
  String? modelData;
  String? title;

  TalentModel({
    this.count,
    this.data,
    this.image,
    this.key,
    this.modelData,
    this.title,
  });

  TalentModel copyWith({
    int? count,
    List<DataMost>? data,
    String? image,
    String? key,
    String? modelData,
    String? title,
  }) =>
      TalentModel(
        count: count ?? this.count,
        data: data ?? this.data,
        image: image ?? this.image,
        key: key ?? this.key,
        modelData: modelData ?? this.modelData,
        title: title ?? this.title,
      );

  factory TalentModel.fromJson(Map<String, dynamic> json) => TalentModel(
        count: json["count"],
        data: List<DataMost>.from(json["data"].map((x) => DataMost.fromJson(x))),
        image: json["image"],
        key: json["key"],
        modelData: json["model_data"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "image": image,
        "key": key,
        "model_data": modelData,
        "title": title,
      };
}

class DataMost {
  int? id;
  String? email;
  String? name;
  String? slug;
  String? avatar;
  String? avatar200;
  String? avatar400;
  String? videoUrl;
  String? video;
  int? profileCompleted;
  String? knowledges;
  String? about;
  bool? sponsored;
  String? city;
  String? position;
  String? country;
  String? career;
  String? workMethodologies;
  String? programsForProductivity;
  String? wantToBe;
  String? onboardingGoal;
  String? myLanguages;
  String? preferWork;
  String? desiredRole;
  String? benefitsInCompanies;
  String? wantToWork;
  String? facebook;
  String? instagram;
  String? twitter;
  String? linkedin;
  String? tiktok;
  String? behance;
  String? pinterest;
  String? github;
  List<dynamic>? archetype;
  List<String>? hobbies;
  List<String>? knowledge;
  List<String>? skills;
  List<String>? tools;
  List<String>? dreamTeam;
  List<String>? dreamBrands;
  List<dynamic>? dreamRoles;
  List<String>? languages;
  List<dynamic>? opencallObjective;
  List<InterestArea>? interestAreas;
  int? resumeId;
  String? resumeDescription;
  bool? resumeDownload;
  String? resumeImage;
  String? resumeName;
  String? connected;
  int? matchesCount;
  bool? save;
  int? reviewCount;
  int? sharedCount;
  int? reviewGeneralUser;
  String? typeAudience;
  List<String>? typeAudiences;
  String? createdAt;
  dynamic compatibility;
  dynamic compatibilityReason;

  DataMost({
    this.id,
    this.email,
    this.name,
    this.slug,
    this.avatar,
    this.avatar200,
    this.avatar400,
    this.videoUrl,
    this.video,
    this.profileCompleted,
    this.knowledges,
    this.about,
    this.sponsored,
    this.city,
    this.position,
    this.country,
    this.career,
    this.workMethodologies,
    this.programsForProductivity,
    this.wantToBe,
    this.onboardingGoal,
    this.myLanguages,
    this.preferWork,
    this.desiredRole,
    this.benefitsInCompanies,
    this.wantToWork,
    this.facebook,
    this.instagram,
    this.twitter,
    this.linkedin,
    this.tiktok,
    this.behance,
    this.pinterest,
    this.github,
    this.archetype,
    this.hobbies,
    this.knowledge,
    this.skills,
    this.tools,
    this.dreamTeam,
    this.dreamBrands,
    this.dreamRoles,
    this.languages,
    this.opencallObjective,
    this.interestAreas,
    this.resumeId,
    this.resumeDescription,
    this.resumeDownload,
    this.resumeImage,
    this.resumeName,
    this.connected,
    this.matchesCount,
    this.save,
    this.reviewCount,
    this.sharedCount,
    this.reviewGeneralUser,
    this.typeAudience,
    this.typeAudiences,
    this.createdAt,
    this.compatibility,
    this.compatibilityReason,
  });

  DataMost copyWith({
    int? id,
    String? email,
    String? name,
    String? slug,
    String? avatar,
    String? avatar200,
    String? avatar400,
    String? videoUrl,
    String? video,
    int? profileCompleted,
    String? knowledges,
    String? about,
    bool? sponsored,
    String? city,
    String? position,
    String? country,
    String? career,
    String? workMethodologies,
    String? programsForProductivity,
    String? wantToBe,
    String? onboardingGoal,
    String? myLanguages,
    String? preferWork,
    String? desiredRole,
    String? benefitsInCompanies,
    String? wantToWork,
    String? facebook,
    String? instagram,
    String? twitter,
    String? linkedin,
    String? tiktok,
    String? behance,
    String? pinterest,
    String? github,
    List<dynamic>? archetype,
    List<String>? hobbies,
    List<String>? knowledge,
    List<String>? skills,
    List<String>? tools,
    List<String>? dreamTeam,
    List<String>? dreamBrands,
    List<dynamic>? dreamRoles,
    List<String>? languages,
    List<dynamic>? opencallObjective,
    List<InterestArea>? interestAreas,
    int? resumeId,
    String? resumeDescription,
    bool? resumeDownload,
    String? resumeImage,
    String? resumeName,
    String? connected,
    int? matchesCount,
    bool? save,
    int? reviewCount,
    int? sharedCount,
    int? reviewGeneralUser,
    String? typeAudience,
    List<String>? typeAudiences,
    String? createdAt,
    dynamic compatibility,
    dynamic compatibilityReason,
  }) =>
      DataMost(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        avatar: avatar ?? this.avatar,
        avatar200: avatar200 ?? this.avatar200,
        avatar400: avatar400 ?? this.avatar400,
        videoUrl: videoUrl ?? this.videoUrl,
        video: video ?? this.video,
        profileCompleted: profileCompleted ?? this.profileCompleted,
        knowledges: knowledges ?? this.knowledges,
        about: about ?? this.about,
        sponsored: sponsored ?? this.sponsored,
        city: city ?? this.city,
        position: position ?? this.position,
        country: country ?? this.country,
        career: career ?? this.career,
        workMethodologies: workMethodologies ?? this.workMethodologies,
        programsForProductivity: programsForProductivity ?? this.programsForProductivity,
        wantToBe: wantToBe ?? this.wantToBe,
        onboardingGoal: onboardingGoal ?? this.onboardingGoal,
        myLanguages: myLanguages ?? this.myLanguages,
        preferWork: preferWork ?? this.preferWork,
        desiredRole: desiredRole ?? this.desiredRole,
        benefitsInCompanies: benefitsInCompanies ?? this.benefitsInCompanies,
        wantToWork: wantToWork ?? this.wantToWork,
        facebook: facebook ?? this.facebook,
        instagram: instagram ?? this.instagram,
        twitter: twitter ?? this.twitter,
        linkedin: linkedin ?? this.linkedin,
        tiktok: tiktok ?? this.tiktok,
        behance: behance ?? this.behance,
        pinterest: pinterest ?? this.pinterest,
        github: github ?? this.github,
        archetype: archetype ?? this.archetype,
        hobbies: hobbies ?? this.hobbies,
        knowledge: knowledge ?? this.knowledge,
        skills: skills ?? this.skills,
        tools: tools ?? this.tools,
        dreamTeam: dreamTeam ?? this.dreamTeam,
        dreamBrands: dreamBrands ?? this.dreamBrands,
        dreamRoles: dreamRoles ?? this.dreamRoles,
        languages: languages ?? this.languages,
        opencallObjective: opencallObjective ?? this.opencallObjective,
        interestAreas: interestAreas ?? this.interestAreas,
        resumeId: resumeId ?? this.resumeId,
        resumeDescription: resumeDescription ?? this.resumeDescription,
        resumeDownload: resumeDownload ?? this.resumeDownload,
        resumeImage: resumeImage ?? this.resumeImage,
        resumeName: resumeName ?? this.resumeName,
        connected: connected ?? this.connected,
        matchesCount: matchesCount ?? this.matchesCount,
        save: save ?? this.save,
        reviewCount: reviewCount ?? this.reviewCount,
        sharedCount: sharedCount ?? this.sharedCount,
        reviewGeneralUser: reviewGeneralUser ?? this.reviewGeneralUser,
        typeAudience: typeAudience ?? this.typeAudience,
        typeAudiences: typeAudiences ?? this.typeAudiences,
        createdAt: createdAt ?? this.createdAt,
        compatibility: compatibility ?? this.compatibility,
        compatibilityReason: compatibilityReason ?? this.compatibilityReason,
      );

  factory DataMost.fromJson(Map<String, dynamic> json) => DataMost(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        slug: json["slug"],
        avatar: json["avatar"],
        avatar200: json["avatar_200"],
        avatar400: json["avatar_400"],
        videoUrl: json["video_url"],
        video: json["video"],
        profileCompleted: json["profile_completed"],
        knowledges: json["knowledges"],
        about: json["about"],
        sponsored: json["sponsored"],
        city: json["city"],
        position: json["position"],
        country: json["country"],
        career: json["career"],
        workMethodologies: json["work_methodologies"],
        programsForProductivity: json["programs_for_productivity"],
        wantToBe: json["want_to_be"],
        onboardingGoal: json["onboarding_goal"],
        myLanguages: json["my_languages"],
        preferWork: json["prefer_work"],
        desiredRole: json["desired_role"],
        benefitsInCompanies: json["benefits_in_companies"],
        wantToWork: json["want_to_work"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        twitter: json["twitter"],
        linkedin: json["linkedin"],
        tiktok: json["tiktok"],
        behance: json["behance"],
        pinterest: json["pinterest"],
        github: json["github"],
        archetype: List<dynamic>.from(json["archetype"].map((x) => x)),
        hobbies: List<String>.from(json["hobbies"].map((x) => x)),
        knowledge: List<String>.from(json["knowledge"].map((x) => x)),
        skills: List<String>.from(json["skills"].map((x) => x)),
        tools: List<String>.from(json["tools"].map((x) => x)),
        dreamTeam: List<String>.from(json["dream_team"].map((x) => x)),
        dreamBrands: List<String>.from(json["dream_brands"].map((x) => x)),
        dreamRoles: List<dynamic>.from(json["dream_roles"].map((x) => x)),
        languages: List<String>.from(json["languages"].map((x) => x)),
        opencallObjective: List<dynamic>.from(json["opencall_objective"].map((x) => x)),
        interestAreas: List<InterestArea>.from(json["interest_areas"].map((x) => InterestArea.fromJson(x))),
        resumeId: json["resume_id"],
        resumeDescription: json["resume_description"],
        resumeDownload: json["resume_download"],
        resumeImage: json["resume_image"],
        resumeName: json["resume_name"],
        connected: json["connected"],
        matchesCount: json["matches_count"],
        save: json["save"],
        reviewCount: json["review_count"],
        sharedCount: json["shared_count"],
        reviewGeneralUser: json["review_general_user"],
        typeAudience: json["type_audience"],
        typeAudiences: List<String>.from(json["type_audiences"].map((x) => x)),
        createdAt: json["created_at"],
        compatibility: json["compatibility"],
        compatibilityReason: json["compatibility_reason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "slug": slug,
        "avatar": avatar,
        "avatar_200": avatar200,
        "avatar_400": avatar400,
        "video_url": videoUrl,
        "video": video,
        "profile_completed": profileCompleted,
        "knowledges": knowledges,
        "about": about,
        "sponsored": sponsored,
        "city": city,
        "position": position,
        "country": country,
        "career": career,
        "work_methodologies": workMethodologies,
        "programs_for_productivity": programsForProductivity,
        "want_to_be": wantToBe,
        "onboarding_goal": onboardingGoal,
        "my_languages": myLanguages,
        "prefer_work": preferWork,
        "desired_role": desiredRole,
        "benefits_in_companies": benefitsInCompanies,
        "want_to_work": wantToWork,
        "facebook": facebook,
        "instagram": instagram,
        "twitter": twitter,
        "linkedin": linkedin,
        "tiktok": tiktok,
        "behance": behance,
        "pinterest": pinterest,
        "github": github,
        "archetype": List<dynamic>.from(archetype!.map((x) => x)),
        "hobbies": List<dynamic>.from(hobbies!.map((x) => x)),
        "knowledge": List<dynamic>.from(knowledge!.map((x) => x)),
        "skills": List<dynamic>.from(skills!.map((x) => x)),
        "tools": List<dynamic>.from(tools!.map((x) => x)),
        "dream_team": List<dynamic>.from(dreamTeam!.map((x) => x)),
        "dream_brands": List<dynamic>.from(dreamBrands!.map((x) => x)),
        "dream_roles": List<dynamic>.from(dreamRoles!.map((x) => x)),
        "languages": List<dynamic>.from(languages!.map((x) => x)),
        "opencall_objective": List<dynamic>.from(opencallObjective!.map((x) => x)),
        "interest_areas": List<dynamic>.from(interestAreas!.map((x) => x.toJson())),
        "resume_id": resumeId,
        "resume_description": resumeDescription,
        "resume_download": resumeDownload,
        "resume_image": resumeImage,
        "resume_name": resumeName,
        "connected": connected,
        "matches_count": matchesCount,
        "save": save,
        "review_count": reviewCount,
        "shared_count": sharedCount,
        "review_general_user": reviewGeneralUser,
        "type_audience": typeAudience,
        "type_audiences": List<dynamic>.from(typeAudiences!.map((x) => x)),
        "created_at": createdAt,
        "compatibility": compatibility,
        "compatibility_reason": compatibilityReason,
      };
}

class InterestArea {
  int? key;
  String? label;

  InterestArea({
    this.key,
    this.label,
  });

  InterestArea copyWith({
    int? key,
    String? label,
  }) =>
      InterestArea(
        key: key ?? this.key,
        label: label ?? this.label,
      );

  factory InterestArea.fromJson(Map<String, dynamic> json) => InterestArea(
        key: json["key"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "label": label,
      };
}
