using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Grid = System.Collections.Generic.Dictionary<string, int>;

namespace Theme.Samples;

/// <summary>Doc comment with <c>markup</c>.</summary>
public delegate void Notify(object? sender, int code);

public enum Level : byte { Off = 0, Warn = 0b10, All = 0xFF }

public interface IShape<T> where T : class {
    T? Value { get; }
    double Area(out bool exact);
}

public record Point(int X, int Y) {
    public static Point Origin => new(0, 0);
    public static Point operator +(Point a, Point b) => new(a.X + b.X, a.Y + b.Y);
}

public abstract class Node {
    protected readonly Grid _grid = new();
    public virtual string Name { get; set; } = "node";
    public abstract int Rank { get; }
}

[Obsolete("use Leaf<T> instead")]
public sealed class Leaf<T> : Node, IShape<T> where T : class, new() {
    private const decimal Ratio = 1.5m;
    private static volatile int s_seen;   // mutable global
    public event Notify? Changed;
    public T? Value { get; private set; }
    public override int Rank => 1;
    public override string Name {
        get => base.Name;
        set => base.Name = value ?? nameof(Leaf<T>);
    }

    public double Area(out bool exact) {
        exact = true;
        goto done;
    done: return (double)Ratio * 2.0e3f; /* cast then scale */
    }

    public async Task<IEnumerable<int>> LoadAsync(params int[] ids) {
        await Task.Delay(100);
        var evens = from id in ids where id % 2 == 0 orderby id select id * 1_000;
        var names = ids.Select(static i => $"#{i:X4}").ToList();
        Console.WriteLine(@"C:\raw\path" + """
            triple quoted
            """);
        try {
            var (lo, hi) = (ids.Min(), ids.Max());
            checked { s_seen |= (hi ^ lo) & ~1; }
            Changed?.Invoke(this, s_seen);
        } catch (InvalidOperationException ex) when (ex.Data is not null) {
            throw new AggregateException($"{typeof(T).Name}\t\u0041", ex);
        } finally { s_seen = 0; }
        return evens.Concat(names.Select(n => n.Length));
    }

    public static IEnumerable<Level> Walk(Level start) {
        for (var l = start; l != Level.Off; l--) {
            if (l == Level.Warn) continue; else if (s_seen < 0) break;
            yield return l switch {
                Level.All => Level.Warn,
                _ when (int)l > 1 => Level.Off,
                _ => start,
            };
        }
    }
}

public static class Ext {
    public static string Describe(this Node n) => n?.Name ?? "none";
}
