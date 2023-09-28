import 'package:_zapp/data_models/crud_model.dart';
import 'package:_zapp/graphql_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.client();

  Future<List<CommentModel>> getComments({required int id}) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
query QUERIES(\$id : ID!){
  comment(id: \$id) {
    id
    name
    email
    body
  }
}
        """),
          variables: {"id": id},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }

      final Map<String, dynamic>? commentData = result.data?['comment'];

      if (commentData == null) {
        return [];
      }

      final CommentModel comment = CommentModel.fromMap(commentData);
      return [comment];
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> deleteComment({required String id}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(fetchPolicy: FetchPolicy.noCache, document: gql("""

mutation MUTATIONS(\$id : ID!){
  deleteComment(id: \$id)
}



"""), variables: {"id": id}),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      throw false;
    }
  }

  Future<bool> createComment(
      {required String name,
      required String email,
      required String body}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(fetchPolicy: FetchPolicy.noCache, document: gql("""

mutation MUTATIONS(\$input : CreateCommentInput!){
  createComment(input : \$input){
    id
    name
    email
    body
  }
}

"""), variables: {
          "input": {"name": name, "email": email, "body": body}
        }),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      throw false;
    }
  }

  Future<bool> updateComment(
      {required String id,
      required String name,
      required String email,
      required String body}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(fetchPolicy: FetchPolicy.noCache, document: gql("""

mutation MUTATIONS(\$id: ID!, \$UpdateCommentInput: UpdateCommentInput!) {
  updateComment(id: \$id, input: \$UpdateCommentInput) {
    id
    name
    email
    body
  }
}


"""), variables: {
          "id": id,
          "UpdateCommentInput": {"name": name, "email": email, "body": body}
        }),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      throw false;
    }
  }
}
