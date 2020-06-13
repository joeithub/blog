title: '@EqualsAndHashCode'
author: Joe Tong
tags:
  - JAVAEE
  - SPRINGBOOT
  - LOMBOK
  - ANNOTATION
categories:
  - IT
date: 2019-10-11 19:45:00
---
原文中提到的大致有以下几点：

1. 此注解会生成equals(Object other) 和 hashCode()方法。

2. 它默认使用非静态，非瞬态的属性

3. 可通过参数exclude排除一些属性

4. 可通过参数of指定仅使用哪些属性

5. 它默认仅使用该类中定义的属性且不调用父类的方法

6. 可通过callSuper=true解决上一点问题。让其生成的方法中调用父类的方法。

 

另：@Data相当于@Getter @Setter @RequiredArgsConstructor @ToString @EqualsAndHashCode这5个注解的合集。

 

通过官方文档，可以得知，当使用@Data注解时，则有了@EqualsAndHashCode注解，那么就会在此类中存在equals(Object other) 和 hashCode()方法，且不会使用父类的属性，这就导致了可能的问题。

比如，有多个类有相同的部分属性，把它们定义到父类中，恰好id（数据库主键）也在父类中，那么就会存在部分对象在比较时，它们并不相等，却因为lombok自动生成的equals(Object other) 和 hashCode()方法判定为相等，从而导致出错。

 

修复此问题的方法很简单：

1. 使用@Getter @Setter @ToString代替@Data并且自定义equals(Object other) 和 hashCode()方法，比如有些类只需要判断主键id是否相等即足矣。

2. 或者使用在使用@Data时同时加上@EqualsAndHashCode(callSuper=true)注解。

---

---

任意类的定义都可以添加@EqualsAndHashCode注解，让lombok帮你生成equals(Object other)和hashCode()方法的实现。默认情况下会使用非静态和非transient型字段来生成，但是你也通过在字段上添加@EqualsAndHashCode.Include或者@EqualsAndHashCode.Exclude修改你使用的字段（甚至指定各种方法的输出）。或者你也可以通过在类上使用@EqualsAndHashCode(onlyExplicitlyIncluded = true)，且在特定字段或特定方法上添加@EqualsAndHashCode.Include来指定他们。

如果将@EqualsAndHashCode添加到继承至另一个类的类上，这个功能会有点棘手。一般情况下，为这样的类自动生成equals和hashCode方法是一个坏思路，因为超类也有定义了一些字段，他们也需要equals/hashCode方法但是不会自动生成。通过设置callSuper=true，可以在生成的equals和hashCode方法里包含超类的方法。对于hashCode，·super.hashCode()·会被包含在hash算法内，而对于equals，如果超类实现认为它与传入的对象不一致则会返回false。注意：并非所有的equals都能正确的处理这样的情况。然而刚好lombok可以，若超类也使用lombok来生成equals方法，那么你可以安全的使用它的equals方法。如果你有一个明确的超类, 你得在callSuper上提供一些值来表示你已经斟酌过，要不然的话就会产生一条警告信息。

当你的类没有继承至任何类（非java.lang.Object, 当然任何类都是继承于Object类的），而你却将callSuer置为true, 这会产生编译错误（译者注： java: Generating equals/hashCode with a supercall to java.lang.Object is pointless. ）。因为这会使得生成的equals和hashCode方法实现只是简单的继承至Object类的方法，只有相同的对象并且相同的hashCode才会判定他们相等。若你的类继承至另一个类又没有设置callSuper, 则会产品一个告警，因为除非超类没有（或者没有跟相等相关的）字段，否则lombok无法为你生成考虑超类声明字段的实现。你需要编写自己的实现，或者依赖callSuper的链式功能。你也可以使用配置关键字lombok.equalsAndHashCode.callSuper.（译者注：配置关键字这里还没搞明白！！！）

NEW in Lombok 0.10:

除非你的类是final类型并且只是继承至java.lang.Object, 否则lombok会生成一个canEqual方法，这以为着JPA代理仍然可以等于他们的基类，但是添加新状态的子类不会破坏equals契约。下文解释了为什么需要这种方法的复杂原因：How to Write an Equality Method in Java。如果层次结构中的所有类都是scala case类和带有lombok生成的equals方法的类的混合，则所有的相等都能正常工作。如果你需要编写自己的equals方法，那么如果更改equals和hashCode方法，都应该始终覆盖canEqual.

NEW in Lombok 1.14.0:

要将注释放在equals的另一个参数（以及相关的canEqual）方法上，可以使用onParam = @ __（{@ AnnotationsHere}）。 但要小心！ 这是一个实验性功能。 有关更多详细信息，请参阅有关onX功能的文档。


看代码示例，最好自己写一下，然后查看编译后的class文件。

```
package com.amos.lombok;


import lombok.EqualsAndHashCode;

/**
 * @author amos
 */
@EqualsAndHashCode
public class EqualsAndHashCodeExample {

    private transient int transientVar = 10;
    private String name;
    private double score;
    /**
     * 不包含该字段
     */
    @EqualsAndHashCode.Exclude
    private Shape shape = new Square(5, 10);
    private String[] tags;
    /**
     * 不包含该字段
     */
    @EqualsAndHashCode.Exclude
    private int id;

    public String getName() {
        return this.name;
    }

    @EqualsAndHashCode(callSuper = true)
    public static class Square extends Shape {
        private final int width, height;

        public Square(int width, int height) {
            this.width = width;
            this.height = height;
        }
    }

    public static class Shape {
    }
}
```

编译后的class文件

```
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.amos.lombok;

import java.util.Arrays;

public class EqualsAndHashCodeExample {
    private transient int transientVar = 10;
    private String name;
    private double score;
    private EqualsAndHashCodeExample.Shape shape = new EqualsAndHashCodeExample.Square(5, 10);
    private String[] tags;
    private int id;

    public EqualsAndHashCodeExample() {
    }

    public String getName() {
        return this.name;
    }

    public boolean equals(final Object o) {
        if (o == this) {
            return true;
        } else if (!(o instanceof EqualsAndHashCodeExample)) {
            return false;
        } else {
            EqualsAndHashCodeExample other = (EqualsAndHashCodeExample)o;
            if (!other.canEqual(this)) {
                return false;
            } else {
                label31: {
                    Object this$name = this.getName();
                    Object other$name = other.getName();
                    if (this$name == null) {
                        if (other$name == null) {
                            break label31;
                        }
                    } else if (this$name.equals(other$name)) {
                        break label31;
                    }

                    return false;
                }

                if (Double.compare(this.score, other.score) != 0) {
                    return false;
                } else {
                    return Arrays.deepEquals(this.tags, other.tags);
                }
            }
        }
    }

    protected boolean canEqual(final Object other) {
        return other instanceof EqualsAndHashCodeExample;
    }

    public int hashCode() {
        int PRIME = true;
        int result = 1;
        Object $name = this.getName();
        int result = result * 59 + ($name == null ? 43 : $name.hashCode());
        long $score = Double.doubleToLongBits(this.score);
        result = result * 59 + (int)($score &gt;&gt;&gt; 32 ^ $score);
        result = result * 59 + Arrays.deepHashCode(this.tags);
        return result;
    }

    public static class Shape {
        public Shape() {
        }
    }

    public static class Square extends EqualsAndHashCodeExample.Shape {
        private final int width;
        private final int height;

        public Square(int width, int height) {
            this.width = width;
            this.height = height;
        }

        public boolean equals(final Object o) {
            if (o == this) {
                return true;
            } else if (!(o instanceof EqualsAndHashCodeExample.Square)) {
                return false;
            } else {
                EqualsAndHashCodeExample.Square other = (EqualsAndHashCodeExample.Square)o;
                if (!other.canEqual(this)) {
                    return false;
                } else if (!super.equals(o)) {
                    return false;
                } else if (this.width != other.width) {
                    return false;
                } else {
                    return this.height == other.height;
                }
            }
        }

        protected boolean canEqual(final Object other) {
            return other instanceof EqualsAndHashCodeExample.Square;
        }

        public int hashCode() {
            int PRIME = true;
            int result = super.hashCode();
            result = result * 59 + this.width;
            result = result * 59 + this.height;
            return result;
        }
    }
}
```

注意
超类不加callSuper且不手动覆写

上述的代码，通过下面的代码测试

```
public static void main(String[] args) {

        Square square1 = new Square(1, 2);
        Square square2 = new Square(1, 2);
        // false
        System.out.println(square1.equals(square2));
    }
```

可以看出，明明对象应该是相等的，但是就是不等！！
因为下面的代码导致，可以看出使用的是Object的equals方法，该方法一定要对象完全一样且hashCode一样才判定相等。

```
else if (!super.equals(o)) {
                    return false;
}
```

所以，为了避免这个问题，你要么手动覆写超类的equals，要么在超类上加callSuper注解。

