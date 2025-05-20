import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:imdaesomun/src/core/theme/app_color.dart';

class HtmlViewPage extends StatelessWidget {
  const HtmlViewPage({super.key});

  final String htmlData = """
  <div class="fr-view"><p>동탄 포레파크 자연&amp; 푸르지오(A76-2BL) 국민주택, 민영주택 입주자 모집공고를 붙임과 같이 게시합니다.</p><p><br></p><p>※ 청약신청은 한국부동산원 &#39;청약Home&#39;홈페이지(www.applyhome.co.kr)를 통해 가능합니다.</p><p><br></p><p>※ 입주자모집공고에 대한 자세한 사항은 첨부된 모집공고문을 확인해 주시기 바랍니다.</p><p><br></p><p>※ 문의처 : 031-373-1762</p></div>
  """;

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Html(
            data: htmlData,
            style: {
              '*': Style(
                color: AppColors.gray900,
                fontFamily: 'Pretendard',
                fontSize: FontSize(16.0),
                fontWeight: FontWeight.w400,
                lineHeight: LineHeight.normal,
                letterSpacing: -0.03,
                textAlign: TextAlign.start,
              ),
            },
          ),
        ),
      ),
    );
  }
}
