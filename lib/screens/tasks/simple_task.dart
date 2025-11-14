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
        'image':
            'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=400',
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
        'image':
            'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400',
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
        'image':
            'https://images.unsplash.com/photo-1574169208507-84376144848b?w=400',
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
        'image':
            'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=400',
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
        'image':
            'https://images.unsplash.com/photo-1519692933481-e162a57d6721?w=400',
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
        'image':
            'https://images.unsplash.com/photo-1551958219-acbc608c6377?w=400',
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
        'image':
            'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=400',
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
        'image':
            'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=400',
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
        'image':
            'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=400',
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
    });
    // Load first lesson after state is updated
    loadLesson(0);
  }

  @override
  Widget getQuestionCard() {
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 420;
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);
    final question =
        currentLesson?['question'] as String? ?? currentLesson?['word'] ?? '';
    final questionLength = question.length;
    double maxFont;
    if (questionLength > 160) {
      maxFont = isCompact ? 18 : 20;
    } else if (questionLength > 110) {
      maxFont = isCompact ? 20 : 22;
    } else if (questionLength > 80) {
      maxFont = isCompact ? 22 : 24;
    } else {
      maxFont = isCompact ? 24 : 26;
    }
    final double minFont = (maxFont - (isCompact ? 4 : 6)).clamp(
      16.0,
      maxFont.toDouble(),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20 * textScaleFactor),
        boxShadow: [
          BoxShadow(
            color: AppColors.softShadow,
            blurRadius: 8 * textScaleFactor,
            offset: Offset(0, 2 * textScaleFactor),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all((isCompact ? 16 : 20) * textScaleFactor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Question text with audio icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ScalableText(
                    question,
                    style: AppTextStyles.headlineLarge(
                      context,
                    ).copyWith(fontSize: maxFont, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                    autoScale: true,
                    minFontSize: minFont,
                    maxFontSize: maxFont,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8 * textScaleFactor),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Audio playback functionality
                    },
                    borderRadius: BorderRadius.circular(20 * textScaleFactor),
                    child: Container(
                      width: 32 * textScaleFactor,
                      height: 32 * textScaleFactor,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.volume_up,
                        color: AppColors.audioIconRed,
                        size: 24 * textScaleFactor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: (isCompact ? 12 : 16) * textScaleFactor),
            // Answer options
            _buildAnswersWidget(),
          ],
        ),
      ),
    );
  }

  @override
  Widget getAnswersDisplay() {
    // Return empty widget since options are now inside question card
    // This prevents duplication in the layout
    return const SizedBox.shrink();
  }

  Widget _buildAnswersWidget() {
    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isCompact = width < 380;
        final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);
        final double gap = (isCompact ? 10 : 12) * textScaleFactor;

        // Create rows of 2 columns with square boxes
        final List<Widget> rows = [];
        for (int i = 0; i < wordsToDisplay.length; i += 2) {
          final rowChildren = <Widget>[];

          // First option in row - square box with constrained size
          rowChildren.add(
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: (isCompact ? 140 : 160) * textScaleFactor,
                ),
                child: AspectRatio(aspectRatio: 1.0, child: getListofWords(i)),
              ),
            ),
          );

          // Gap between columns
          if (i + 1 < wordsToDisplay.length) {
            rowChildren.add(SizedBox(width: gap));
          }

          // Second option in row (if exists) - square box
          if (i + 1 < wordsToDisplay.length) {
            rowChildren.add(
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: (isCompact ? 140 : 160) * textScaleFactor,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: getListofWords(i + 1),
                  ),
                ),
              ),
            );
          } else {
            // Empty space if odd number of options
            rowChildren.add(const Expanded(child: SizedBox()));
          }

          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowChildren,
            ),
          );

          // Add spacing between rows
          if (i + 2 < wordsToDisplay.length) {
            rows.add(SizedBox(height: gap));
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: rows,
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
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);

    // Get option image if available (for future enhancement)
    // For now, use question image or placeholder
    final optionImageUrl = currentLesson?['optionImages']?[index] as String?;
    final questionImageUrl = currentLesson?['image'] as String?;
    final displayImageUrl = optionImageUrl ?? questionImageUrl;

    Color borderColor = AppColors.border;
    List<BoxShadow> shadows = [
      BoxShadow(
        color: AppColors.softShadow,
        blurRadius: 8 * textScaleFactor,
        offset: Offset(0, 2 * textScaleFactor),
      ),
    ];

    if (isCorrect) {
      borderColor = AppColors.success;
      shadows = [
        BoxShadow(
          color: AppColors.success.withOpacity(0.3),
          blurRadius: 12 * textScaleFactor,
          offset: Offset(0, 4 * textScaleFactor),
        ),
      ];
    } else if (isIncorrect) {
      borderColor = AppColors.error;
      shadows = [
        BoxShadow(
          color: AppColors.error.withOpacity(0.2),
          blurRadius: 8 * textScaleFactor,
          offset: Offset(0, 2 * textScaleFactor),
        ),
      ];
    } else if (isSelected) {
      borderColor = AppColors.headerOrange;
      shadows = [
        BoxShadow(
          color: AppColors.headerOrange.withOpacity(0.25),
          blurRadius: 10 * textScaleFactor,
          offset: Offset(0, 3 * textScaleFactor),
        ),
      ];
    }

    return GestureDetector(
      onTap: () => verifyWords(index),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20 * textScaleFactor),
          border: Border.all(
            color: borderColor,
            width: (isSelected ? 2 : 1.5) * textScaleFactor,
          ),
          boxShadow: shadows,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image container - constrained size
            Flexible(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20 * textScaleFactor),
                  topRight: Radius.circular(20 * textScaleFactor),
                ),
                child: Container(
                  width: double.infinity,
                  color: AppColors.border.withOpacity(0.2),
                  child: displayImageUrl != null && displayImageUrl.isNotEmpty
                      ? Image.network(
                          displayImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8 * textScaleFactor),
                              child: Icon(
                                Icons.image_not_supported,
                                size: 32 * textScaleFactor,
                                color: AppColors.border,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8 * textScaleFactor),
                              child: SizedBox(
                                width: 24 * textScaleFactor,
                                height: 24 * textScaleFactor,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2 * textScaleFactor,
                                  color: AppColors.progressRed,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8 * textScaleFactor),
                          child: Icon(
                            Icons.image,
                            size: 32 * textScaleFactor,
                            color: AppColors.border,
                          ),
                        ),
                ),
              ),
            ),
            // Text label - compact
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8 * textScaleFactor,
                vertical: 8 * textScaleFactor,
              ),
              child: Text(
                word,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  fontSize: 14 * textScaleFactor,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
