
import 'package:flutter/material.dart';
import 'package:x_money_manager/model/MA_Response.dart';

void maShowSnackBar({required BuildContext context, required String message, bool? error, bool? info, bool? success, bool? warning}){
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              backgroundColor: ((error??false) ? Theme.of(context).colorScheme.error : 
                                          ((success??false) ? Theme.of(context).colorScheme.primary : 
                                            ((warning??false) ? Theme.of(context).colorScheme.secondary : 
                                            Colors.transparent))),
              content: Text(message),
              dismissDirection :DismissDirection.up,
              behavior:SnackBarBehavior.floating,
              elevation: 12,
             ),
          );
}
Future<void> mashowMyDialog({required BuildContext parentcontext, required String title, Icon? icon,Widget? body,List<Widget>? actions, bool? barrierDismissible}) async {
  return showDialog<void>(
    context: parentcontext,
    barrierDismissible:barrierDismissible ?? true, // if false, user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        icon: icon,
        title:  Center(child: Text(title)),
        content:  SingleChildScrollView(
          child: body ,/*ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),*/
        ),
        actions: actions,/*<Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],*/
      );
    },
  );
}

Future<void> showCompleteActionToast({required BuildContext pContext, dynamic Function(BuildContext)? callback, MaResponse? response}) async {
                await mashowMyDialog(
                      barrierDismissible: false,
                      parentcontext: pContext,
                      title: 'result',
                      icon: (response?.error ?? false) ? Icon(Icons.error, size: 50, color: Theme.of(pContext).colorScheme.error,) : Icon(Icons.check, size: 50, color: Theme.of(pContext).colorScheme.primary,),
                      body : ListBody(
                              children: <Widget>[
                                Text('${response?.message}'),
                              ],
                            ),
                      actions: <Widget>[
                            TextButton(
                              child: const Text('close'),
                              onPressed: () async{
                                Navigator.of(pContext).pop();
                                callback!=null ? callback(pContext) : null;
                              },
                            ),
                          ],
                 );
            
   }