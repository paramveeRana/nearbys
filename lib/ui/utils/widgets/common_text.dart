
import 'package:flutter/material.dart';
import 'package:sccore_sync/ui/utils/theme/app_colors.dart';
import 'package:sccore_sync/ui/utils/theme/text_styles.dart';

class CommonText extends StatelessWidget {
  final String title;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? fontSize;
  final Color? clrFont;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final TextStyle? style;
  final TextOverflow? overflow;
  final bool? softWrap;

  const CommonText({super.key, this.title = '', this.fontWeight, this.fontStyle, this.softWrap,this.fontSize, this.clrFont, this.maxLines, this.textAlign, this.textDecoration, this.style, this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      softWrap: softWrap,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      style:
      style ??
          TextStyle(
            fontFamily: TextStyles.fontFamily,
            fontWeight: fontWeight ?? TextStyles.fwRegular,
            fontSize: fontSize ?? 14,
            color: clrFont ?? AppColors.black,
            fontStyle: fontStyle ?? FontStyle.normal,
            decorationColor: clrFont ?? AppColors.black,
            decoration: textDecoration ?? TextDecoration.none,
          ),
    );
  }
}
