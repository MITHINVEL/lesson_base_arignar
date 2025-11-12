import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/screens/lessons/lessons_base.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/scalable_text.dart';

class SimpleTask extends LessonsBase {
  const SimpleTask({
    super.key,
    required super.chapterID,
    required super.lessonID,
    required super.onLessonComplete,
    required super.onExitPressed,
    required super.onJumpToQuestion,
    required super.onPrevLessonPressed,
  });

  @override
  State<SimpleTask> createState() => _SimpleTaskState();
}

class _SimpleTaskState extends LessonsBaseState<SimpleTask> {
  @override
  void setDisplayType() {
    displayType = 'Words';
  }

  @override
  void setSkillType() {
    skillType = 'Reading';
  }

  @override
  void setGamesLogic() {
    final demoLessons = [
      {
        'title': 'இயற்கை & பருவங்கள்',
        'question':
            'குளிர்காலத்திற்குப் பிறகும் கோடைகாலத்திற்கு முன்பும் வரும் பருவம் எது?',
        'options': [
          'இது பனி மற்றும் பனிக்கட்டி உள்ள குளிரான பருவம்.',
          'இது மலர்கள் பூக்கும் மற்றும் மரங்கள் புதிய இலைகள் வளரும் பருவம்.',
          'இது நீண்ட சூரிய ஒளி நாட்கள் உள்ள வெப்பமான பருவம்.',
          'இது இலைகள் நிறம் மாறி விழும் பருவம்.',
        ],
        'correctIndex': 1,
      },
      {
        'title': 'உணவு & சமையல்',
        'question': 'காலையில் சாப்பிடும் உணவை என்ன அழைக்கிறீர்கள்?',
        'options': [
          'இது நாளின் முதல் உணவு, பொதுவாக மதியத்திற்கு முன் சாப்பிடப்படுகிறது.',
          'இது நாளின் நடுப்பகுதியில் சாப்பிடப்படும் உணவு.',
          'இது நாளின் கடைசி உணவு, மாலையில் சாப்பிடப்படுகிறது.',
          'இது முக்கிய உணவுகளுக்கு இடையில் சாப்பிடப்படும் சிறிய உணவு.',
        ],
        'correctIndex': 0,
      },
      {
        'title': 'உடல் பாகங்கள்',
        'question': 'உடலின் எந்த பகுதி பார்ப்பதற்கு உதவுகிறது?',
        'options': [
          'இவை உங்களைச் சுற்றியுள்ள ஒலிகளைக் கேட்பதற்குப் பயன்படுகின்றன.',
          'இவை பார்ப்பதற்கும் வாசிப்பதற்கும் பயன்படுகின்றன.',
          'இவை வெவ்வேறு வாசனைகளை முகர்வதற்குப் பயன்படுகின்றன.',
          'இவை உணவை சுவைப்பதற்குப் பயன்படுகின்றன.',
        ],
        'correctIndex': 1,
      },
      {
        'title': 'பள்ளி & கற்றல்',
        'question': 'காகிதத்தில் எழுத என்ன பயன்படுத்துகிறீர்கள்?',
        'options': [
          'இது வார்த்தைகளை எழுத மை கொண்ட கருவி.',
          'இது காகிதத்தில் தவறுகளை அழிப்பதற்குப் பயன்படுகிறது.',
          'இது காகிதத்தை துண்டுகளாக வெட்டுவதற்குப் பயன்படுகிறது.',
          'இது நீளத்தை அளவிடவும் கோடுகள் வரையவும் பயன்படுகிறது.',
        ],
        'correctIndex': 0,
      },
      {
        'title': 'வானிலை & காலநிலை',
        'question': 'மழை பெய்யும்போது வானத்திலிருந்து என்ன விழுகிறது?',
        'options': [
          'இவை குளிர்காலத்தில் விழும் உறைந்த படிகங்கள்.',
          'இவை மேகங்களிலிருந்து விழும் நீர் துளிகள்.',
          'இவை வானத்தில் பிரகாசமான ஒளி பளபளப்புகள்.',
          'இவை புயல்களின் போது கேட்கப்படும் உரத்த ஒலிகள்.',
        ],
        'correctIndex': 1,
      },
      {
        'title': 'விளையாட்டு & விளையாட்டுகள்',
        'question':
            'பந்து மற்றும் இரண்டு அணிகளுடன் விளையாடப்படும் விளையாட்டு எது?',
        'options': [
          'இது வீரர்கள் பந்தை கோலுக்குள் உதைக்கும் விளையாட்டு.',
          'இது மட்டையுடன் மற்றும் சிறிய பந்துடன் விளையாடப்படும் விளையாட்டு.',
          'இது வீரர்கள் பந்தை வலையின் மேல் அடிக்கும் விளையாட்டு.',
          'இது பனியில் குச்சிகள் மற்றும் பக் கொண்டு விளையாடப்படும் விளையாட்டு.',
        ],
        'correctIndex': 0,
      },
      {
        'title': 'இசை & இசைக்கருவிகள்',
        'question':
            'நாண்கள் கொண்ட மற்றும் விரல்களால் வாசிக்கப்படும் இசைக்கருவி எது?',
        'options': [
          'இது இழுத்து அல்லது வாசிப்பதன் மூலம் வாசிக்கப்படும் நாண் இசைக்கருவி.',
          'இது கருப்பு மற்றும் வெள்ளை விசைகள் கொண்ட விசைப்பலகை இசைக்கருவி.',
          'இது காற்றை ஊதி வாசிக்கப்படும் காற்று இசைக்கருவி.',
          'இது குச்சிகளால் அடித்து வாசிக்கப்படும் தாள இசைக்கருவி.',
        ],
        'correctIndex': 0,
      },
      {
        'title': 'வீடு & குடும்பம்',
        'question': 'உங்கள் அம்மாவின் சகோதரி யார்?',
        'options': [
          'அவள் உங்கள் அம்மாவின் சகோதரி மற்றும் உங்கள் உறவினர்.',
          'அவர் உங்கள் அப்பாவின் சகோதரர் மற்றும் உங்கள் உறவினர்.',
          'அவள் உங்கள் அப்பாவின் சகோதரி மற்றும் உங்கள் உறவினர்.',
          'அவர் உங்கள் அம்மாவின் சகோதரர் மற்றும் உங்கள் உறவினர்.',
        ],
        'correctIndex': 0,
      },
      {
        'title': 'நேரம் & நாட்காட்டி',
        'question': 'ஒரு வாரத்தில் எத்தனை நாட்கள் உள்ளன?',
        'options': [
          'திங்கள் முதல் ஞாயிறு வரை ஏழு நாட்கள் உள்ளன.',
          'ஒரு மாதத்தில் முப்பது நாட்கள் உள்ளன.',
          'ஒரு வருடத்தில் பன்னிரண்டு மாதங்கள் உள்ளன.',
          'ஒரு நாளில் இருபத்தி நான்கு மணி நேரம் உள்ளது.',
        ],
        'correctIndex': 0,
      },
    ];

    setState(() {
      lessons = demoLessons;
      isLoaded = true;
      loadLesson(0);
    });
  }

  @override
  Widget getQuestionCard() {
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 420;
    final question =
        currentLesson?['question'] as String? ?? currentLesson?['word'] ?? '';
    final questionLength = question.length;
    double maxFont;
    if (questionLength > 160) {
      maxFont = isCompact ? 22 : 26;
    } else if (questionLength > 110) {
      maxFont = isCompact ? 25 : 30;
    } else if (questionLength > 80) {
      maxFont = isCompact ? 28 : 32;
    } else {
      maxFont = isCompact ? 30 : 34;
    }
    final double minFont = (maxFont - (isCompact ? 8 : 10)).clamp(
      14.0,
      maxFont.toDouble(),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _buildPill(displayType),
                const SizedBox(width: 8),
                _buildPill(skillType),
              ],
            ),
            if (embeddedMetadata?.subtitle?.isNotEmpty ?? false) ...[
              SizedBox(height: isCompact ? 8 : 12),
              ScalableText(
                embeddedMetadata!.subtitle!,
                style: AppTextStyles.bodyMedium(
                  context,
                ).copyWith(color: AppColors.subtleText),
                maxFontSize: 18,
                minFontSize: 12,
                textAlign: TextAlign.left,
              ),
            ],
            SizedBox(height: isCompact ? 8 : 12),
            ScalableText(
              'Select the correct word',
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
              autoScale: true,
              maxFontSize: isCompact ? 16 : 18,
              minFontSize: isCompact ? 12 : 13,
            ),
            SizedBox(height: isCompact ? 4 : 6),
            ScalableText(
              question,
              style: AppTextStyles.headlineLarge(context),
              textAlign: TextAlign.left,
              autoScale: true,
              minFontSize: minFont < 14 ? 14 : minFont,
              maxFontSize: maxFont,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String label) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: ScalableText(
        label,
        style: AppTextStyles.bodyMedium(
          context,
        ).copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
        autoScale: true,
        maxFontSize: 18,
        minFontSize: 18,
      ),
    );
  }

  @override
  Widget getAnswersDisplay() {
    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width < 380
            ? 1
            : width < 720
            ? 2
            : 4;
        final double crossAxisSpacing = width < 380 ? 8 : 10;
        final double mainAxisSpacing = width < 380 ? 8 : 10;
        final double itemWidth =
            (width - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;

        // Calculate minimum height needed for text (3 lines max)
        final double minOptionHeight = width < 380
            ? 70.0
            : width < 720
            ? 80.0
            : 90.0;
        final double childAspectRatio = itemWidth / minOptionHeight;

        return GridView.builder(
          itemCount: wordsToDisplay.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => getListofWords(index),
        );
      },
    );
  }

  @override
  Widget getListofWords(int index) {
    final word = wordsToDisplay[index];
    final isSelected = selectedOptionIndex == index;
    final isCorrect = isSelected && isCurrentAnswerCorrect == true;
    final isIncorrect = isSelected && isCurrentAnswerCorrect == false;

    Color backgroundColor = AppColors.primaryYellow.withOpacity(0.2);
    Color borderColor = AppColors.primaryYellow.withOpacity(0.6);

    if (isCorrect) {
      backgroundColor = AppColors.success.withOpacity(0.18);
      borderColor = AppColors.success;
    } else if (isIncorrect) {
      backgroundColor = AppColors.error.withOpacity(0.18);
      borderColor = AppColors.error;
    }

    return LayoutBuilder(
      builder: (context, itemConstraints) {
        final itemWidth = itemConstraints.maxWidth;
        final itemHeight = itemConstraints.maxHeight.isFinite
            ? itemConstraints.maxHeight
            : 90.0;
        final fontSize = itemWidth < 120
            ? 11.5
            : itemWidth < 170
            ? 12.0
            : 12.5;

        return GestureDetector(
          onTap: () => verifyWords(index),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: itemHeight,
              maxWidth: itemWidth,
              minHeight: 0,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  word,
                  style: AppTextStyles.bodyMedium(
                    context,
                  ).copyWith(fontSize: fontSize, height: 1.25),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
