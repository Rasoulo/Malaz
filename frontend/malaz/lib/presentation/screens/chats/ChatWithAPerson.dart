import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatWithAPerson extends StatelessWidget {

  const ChatWithAPerson({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          context.pop();
        }, icon: Icon(Icons.arrow_back_sharp,size: 36,)),
        toolbarHeight: 80,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&fit=crop'),
              //backgroundColor: colorScheme.surface,
            ),
            SizedBox(
              width: 18,
            ),
            Text(
              'Chat Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(
                angle: 0.36,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 60,
                    crossAxisSpacing: 60,
                  ),
                  itemBuilder: (context, index) {
                    return Transform.rotate(
                      angle: (index % 2 == 0) ? 0.3 : -0.3, // دورة خفيفة يمين ويسار
                      child: Image.asset(
                        'assets/icons/key_logo.png',
                        color: colorScheme.primary,
                        //colorBlendMode: BlendMode.modulate,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                  itemCount: 50, // عدد كاف لتغطية الخلفية
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ChatBubble(),
                    SizedBox(height: 16,),
                    ChatBubbleForFriend(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  //controller: controller,
                  // onSubmitted: (data) async {
                  //   if(data.trim().isEmpty) return;
                  //   await messages.add({
                  //     'message': data,
                  //     'createdAt': DateTime.now(),
                  //     'id': email,
                  //   });
                  // controller.clear();

                  //   await Future.delayed(Duration(milliseconds: 100));
                  //   _controller.animateTo(
                  //     _controller.position.maxScrollExtent,
                  //     duration: Duration(milliseconds: 300),
                  //     curve: Curves.easeOut,
                  //   );
                  // },
                  decoration: InputDecoration(
                    hintText: 'Send Message...',
                    hintStyle: TextStyle(color: colorScheme.secondary),
                    suffixIcon: Icon(
                      Icons.send,
                      color: colorScheme.primary,// kPrimaryColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.primary,// kPrimaryColor,
                        )
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.primary,// kPrimaryColor,
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ChatBubble extends StatelessWidget {
  ChatBubble ({
    super.key,
    //required this.message,
    //required this.userInfo,
  });
  //final MessageModel message;
  //final UserModel userInfo;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 8,
        ),
        margin: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 10, offset: const Offset(0, 4))],
          border: BoxBorder.all(color: colorScheme.primary),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Hello My Name is abrar.... dkjsehuc dekfjwe beuwh',
              //message.message,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Text('20:00', style: TextStyle(color: colorScheme.secondary,fontSize: 10),),
          ],
        ),
      ),
    );
  }
}
class ChatBubbleForFriend extends StatelessWidget {
  //final MessageModel message;

  ChatBubbleForFriend ({
    super.key,
    //required this.message,
  });
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 8,
        ),
        margin: EdgeInsets.only(
          top: 4,
          left: 16,
          right: 16,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 10, offset: const Offset(0, 4))],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          color: colorScheme.primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Hello my friend.. fdg fbd fdgr regr regger rerg rgeger reg ',
              //message.message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Text('20:00', style: TextStyle(color: colorScheme.surface,fontSize: 10),),
          ],
        ),
      ),
    );
  }
}
