import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pay_note/controllers/category_controller.dart';
import 'package:pay_note/controllers/theme_mode_controller.dart';

class ViewCategoryScreen extends StatelessWidget {
  ViewCategoryScreen({super.key});
  
  final _categoryController = Get.put(CategoryController());
  final _themeModeController = Get.put(ThemeModeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeModeController.isDark
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          'categories'.tr,
          style: GoogleFonts.kantumruyPro(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<CategoryController>(
        builder: (_) {
          if (_categoryController.isLoading) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: _themeModeController.isDark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                size: 25.0,
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await _categoryController.getUserCategories();
              },
              color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
              
                    // search
                    _buildSearchBar(context),
              
                    // expense
                    const SizedBox(height: 15.0),
                    _buildCategoryDropdown(
                      title: 'expense categories'.tr,
                      categories: _categoryController.searchedExpenseCategories.isNotEmpty
                          ? _categoryController.searchedExpenseCategories
                          : _categoryController.expenseCategoryOptions,
                      context: context,
                    ),
              
                    // income
                    _buildCategoryDropdown(
                      title: 'income categories'.tr,
                      categories: _categoryController.searchedIncomeCategories.isNotEmpty
                          ? _categoryController.searchedIncomeCategories
                          : _categoryController.incomeCategoryOptions,
                      context: context,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (_) {
        return TextField(
          controller: _categoryController.searchController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
            ),
            hintText: 'search categories'.tr,
            hintStyle: GoogleFonts.kantumruyPro(
              fontSize: 15.0,
              color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor,
            ),
            filled: true,
            fillColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
            suffixIcon: Visibility(
              visible: _categoryController.isClearText,
              child: IconButton(
                onPressed: () {
                  _categoryController.clearTextAndList();
                },
                icon: Icon(
                  Icons.clear,
                  color: _themeModeController.isDark
                    ? Colors.white
                    : Theme.of(context).primaryColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
          onChanged: (query) {
            _categoryController.searchAllCategories(query);
            _categoryController.showAndHideClearText(query.isNotEmpty);
          },
        );
      }
    );
  }

  Widget _buildCategoryDropdown({
    required String title,
    required List<String> categories,
    required BuildContext context,
  }) {
    bool isExpanded = _categoryController.isDropdownExpanded(title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.kantumruyPro(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: _themeModeController.isDark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _showAddCategoryDialog(
                      context: context,
                      title: title,
                    );
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: _themeModeController.isDark
                          ? Colors.white.withOpacity(0.1)
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                GestureDetector(
                  onTap: () {
                    _categoryController.toggleDropdownExpansion(title);
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: _themeModeController.isDark
                          ? Colors.white.withOpacity(0.1)
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isExpanded
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      color: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10.0),
        if (isExpanded)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {

              String category = categories[index];
              bool isDefaultCategory = _categoryController.expenseDefaultCategories.contains(category) || _categoryController.incomeDefaultCategories.contains(category);

              // Check if the category is custom (not default)
              bool isCustomCategory = !isDefaultCategory;

              return isCustomCategory
                  ? Slidable(
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        dragDismissible: true,
                        children: [

                          // delete category
                          SlidableAction(
                            autoClose: true,
                            onPressed: (context) {

                              // determine if category is for Expense or Income
                              final type = title == 'expense categories'.tr ? 'Expense' : 'Income';
                              _categoryController.deleteCategory(
                                category: category,
                                type: type,
                              );
                            },
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            icon: Icons.delete,
                            backgroundColor: _themeModeController.isDark
                                ? Colors.white.withOpacity(0.1)
                                : Colors.pink,
                            foregroundColor: Colors.white,
                            label: 'delete'.tr,
                          ),

                          // update category
                          SlidableAction(
                            autoClose: true,
                            onPressed: (context) {

                              // determine if the category is for Expense or Income
                              final type = title == 'expense categories'.tr ? 'Expense' : 'Income';
                              _showUpdateCategoryDialog(
                                context: context,
                                currentCategory: category,
                                type: type,
                              );
                            },
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            icon: Icons.edit,
                            backgroundColor: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            label: 'update'.tr,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: Container(
                          height: 60.0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: _themeModeController.isDark ? Colors.white.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              // right content
                              Text(
                                category,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: _themeModeController.isDark ? Colors.white : Theme.of(context).primaryColor
                                ),
                              ),

                              // left content
                              Text(
                                'custom'.tr,
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 13.0,
                                  color: Colors.pink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        height: 60.0,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: _themeModeController.isDark
                              ? Colors.white.withOpacity(0.1)
                              : Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // left content
                            Text(
                              category.tr,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: _themeModeController.isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                            ),

                            // right content
                            Text(
                              isDefaultCategory ? 'default'.tr : 'custom'.tr,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 13.0,
                                color: _themeModeController.isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
      ],
    );
  }

  // update
  void _showUpdateCategoryDialog({
    required BuildContext context,
    required String currentCategory,
    required String type,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<CategoryController>(
          builder: (_) {
            _categoryController.updateCategoryController.text = currentCategory;
            return AlertDialog(
              title: Text(
                
                // determine the title based on the type
                type == 'Expense' ? 'update expense category'.tr : 'update income category'.tr,
                style: GoogleFonts.kantumruyPro(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: _themeModeController.isDark
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
              content: TextField(
                controller: _categoryController.updateCategoryController,
                decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'enter new category'.tr,
                hintStyle: GoogleFonts.kantumruyPro(
                  fontSize: 15.0,
                  color: _themeModeController.isDark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                ),
                fillColor: _themeModeController.isDark
                    ? Colors.white.withOpacity(0.1)
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                filled: true,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'cancel'.tr,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      color: _themeModeController.isDark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    String updateCategoryName = _categoryController.updateCategoryController.text.trim();
                    if (updateCategoryName.isNotEmpty) {
                      _categoryController.updateCategory(
                        oldCategory: currentCategory,
                        newCategory: updateCategoryName,
                        type: type,
                      ).whenComplete(
                        (){
                          _categoryController.updateCategoryController.clear();
                          Get.back();
                        }
                      );
                    }
                  },
                  child: Text(
                    _categoryController.isUpdating ? 'updating'.tr : 'update'.tr,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      color: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

  // add category
  void _showAddCategoryDialog({
    required BuildContext context,
    required String title,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<CategoryController>(
          builder: (_) {
            return AlertDialog(
              title: Text(

                // use the title parameter to determine the title
                title.contains('Expense') ? 'add new expense category'.tr : 'add new income category'.tr,

                style: GoogleFonts.kantumruyPro(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: _themeModeController.isDark
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _categoryController.newCategoryController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'enter new category'.tr,
                      hintStyle: GoogleFonts.kantumruyPro(
                        fontSize: 15.0,
                        color: _themeModeController.isDark
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                      fillColor: _themeModeController.isDark
                          ? Colors.white.withOpacity(0.1)
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'cancel'.tr,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      color: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  child: Text(
                    _categoryController.isAdding ? 'adding'.tr : 'add'.tr,
                    style: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      color: _themeModeController.isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () {
                    String newCategory = _categoryController.newCategoryController.text.trim();
                    if (newCategory.isNotEmpty) {
                      _categoryController.addNewCategory(
                        newCategory: newCategory,
                        type: title.contains('Expense') ? 'Expense' : 'Income',
                      ).whenComplete(
                        () {
                          _categoryController.newCategoryController.clear();
                          Get.back();
                        },
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
