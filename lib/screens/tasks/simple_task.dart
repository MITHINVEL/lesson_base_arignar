import 'package:flutter/material.dart';
import 'package:lesson_base_arignar/screens/lessons/lessons_base.dart';
import 'package:lesson_base_arignar/theme/app_colors.dart';
import 'package:lesson_base_arignar/theme/app_text_styles.dart';
import 'package:lesson_base_arignar/widgets/density/app_button.dart';
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
    final question =
        currentLesson?['question'] as String? ?? currentLesson?['word'] ?? '';
    final imageUrl = currentLesson?['image'] as String?;
    final questionLength = question.length;
    double maxFont;
    if (questionLength > 160) {
      maxFont = isCompact ? 15 : 17;
    } else if (questionLength > 110) {
      maxFont = isCompact ? 17 : 19;
    } else if (questionLength > 80) {
      maxFont = isCompact ? 19 : 21;
    } else {
      maxFont = isCompact ? 20 : 22;
    }
    final double minFont = (maxFont - (isCompact ? 6 : 8)).clamp(
      12.0,
      maxFont.toDouble(),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 8 : 12),
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

            SizedBox(height: isCompact ? 4 : 6),
            ScalableText(
              'Select the correct word',
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
              autoScale: true,
              maxFontSize: isCompact ? 12 : 13,
              minFontSize: isCompact ? 11 : 12,
            ),
            SizedBox(height: isCompact ? 3 : 4),
            ScalableText(
              question,
              style: AppTextStyles.headlineLarge(context),
              textAlign: TextAlign.left,
              autoScale: true,
              minFontSize: minFont < 14 ? 14 : minFont,
              maxFontSize: maxFont,
              maxLines: 2,
            ),
            if (imageUrl != null) ...[
              SizedBox(height: isCompact ? 12 : 16),
              Center(child: _buildQuestionImage(imageUrl, isCompact)),
            ],
            SizedBox(height: isCompact ? 12 : 16),
            // Options inside the same container
            _buildAnswersWidget(),
            SizedBox(height: isCompact ? 12 : 16),
            // Navigation buttons inside the same container
            _buildNavigationButtons(isCompact),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(bool isCompact) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompactWidth = constraints.maxWidth < 680;
        final buttonHeight = 36.0;
        final buttons = [
          AppButton(
            label: 'Previous',
            onPressed: () => previousQuestion(),
            height: buttonHeight,
          ),
          AppButton(
            label: 'Jump to Question',
            onPressed: widget.onJumpToQuestion,
            height: buttonHeight,
          ),
          AppButton(
            label: 'Next',
            onPressed: () => nextQuestion(),
            height: buttonHeight,
          ),
        ];

        if (isCompactWidth) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < buttons.length; i++) ...[
                buttons[i],
                if (i != buttons.length - 1) const SizedBox(height: 16),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < buttons.length; i++) ...[
              Expanded(child: buttons[i]),
              if (i != buttons.length - 1) const SizedBox(width: 20),
            ],
          ],
        );
      },
    );
  }

  Widget _buildQuestionImage(String imageUrl, bool isCompact) {
    // Taller image height to show full image without cropping
    final imageHeight = isCompact ? 160.0 : 180.0;

    return Container(
      height: imageHeight,
      width: imageHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: imageUrl.startsWith('http')
            ? Image.network(
                imageUrl,
                height: imageHeight,
                width: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: imageHeight,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: AppColors.border,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: imageHeight,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.primaryBlue,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
            : Image.asset(
                imageUrl,
                height: imageHeight,
                width: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: imageHeight,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: AppColors.border,
                    ),
                  );
                },
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ScalableText(
        label,
        style: AppTextStyles.bodyMedium(
          context,
        ).copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
        autoScale: true,
        maxFontSize: 14,
        minFontSize: 14,
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
        final double crossAxisSpacing = width < 380 ? 8 : 10;
        final double mainAxisSpacing = width < 380 ? 8 : 10;

        // Calculate the item width first
        final itemWidth = width < 380
            ? width
            : width < 720
            ? (width - crossAxisSpacing) / 2
            : (width - (crossAxisSpacing * 3)) / 4;

        // Calculate max height needed for all options
        final fontSize = itemWidth < 120
            ? 13.0
            : itemWidth < 170
            ? 14.0
            : 17.0;

        // Estimate lines needed for each option and find the max
        double maxHeightNeeded =
            70.0; // minimum height - reduced for compact layout
        for (final word in wordsToDisplay) {
          // Rough character count per line based on font size and width
          final charsPerLine = (itemWidth - 20) ~/ (fontSize * 0.55);
          final estimatedLines = (word.length / charsPerLine).ceil();
          final estimatedHeight =
              (estimatedLines * fontSize * 1.6) +
              25; // padding + spacing - reduced
          if (estimatedHeight > maxHeightNeeded) {
            maxHeightNeeded = estimatedHeight;
          }
        }

        // Cap the maximum height to prevent excessively tall boxes - reduced range
        maxHeightNeeded = maxHeightNeeded.clamp(70.0, 150.0);

        return Wrap(
          spacing: crossAxisSpacing,
          runSpacing: mainAxisSpacing,
          children: wordsToDisplay.asMap().entries.map((entry) {
            final index = entry.key;
            return SizedBox(
              width: itemWidth,
              child: getListofWords(index, maxHeightNeeded),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget getListofWords(int index, [double? uniformHeight]) {
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
        final fontSize = itemWidth < 120
            ? 13.0
            : itemWidth < 170
            ? 14.0
            : 17.0;

        // Use provided uniform height or calculate based on screen width
        final height = uniformHeight ?? (itemWidth < 380 ? 100.0 : 120.0);

        return GestureDetector(
          onTap: () => verifyWords(index),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: itemWidth,
              minHeight: height,
              maxHeight: height,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  word,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    fontSize: fontSize,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
